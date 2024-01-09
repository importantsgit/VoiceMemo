//
//  VoiceRecorderViewModel.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/12/21.
//

import AVFoundation

class VoiceRecorderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    // NSObject delegate 채택하거나 상속받는 이유 -> AVAudioPlayerDelegate은 NSObject 프로토콜 내부에서 채택하고 있음
    // 이러면 필수 AVAudioPlayerDelegate의 필수 메소드를 다 구현할 필요 없음
    
    @Published var isDisplayRemoveVoiceRecorderAlert: Bool
    @Published var isDisplayAlert: Bool
    @Published var alertMessage: String
    
    /// 음성 메모 녹음 관련 프로퍼티
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording: Bool
    
    /// 음성 메모 재생 관련 프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool
    @Published var isPaused: Bool
    @Published var playedTime: TimeInterval
    private var progressTimer: Timer?
    
    /// 음성 메모된 파일
    var recordedFiles: [URL]
    
    /// 현재 선택된 음성메모 파일
    @Published var selectedRecordedFile: URL?
    
    // 폴더 파일 이름
    private let directoryName = "VoiceMemo"
    let fileManager = FileManager.default
    
    init(
        isDisplayRemoveVoiceRecorderAlert: Bool = false,
        isDisplayAlert: Bool = false,
        alertMessage: String = "",
        isRecording: Bool = false,
        isPlaying: Bool = false,
        isPaused: Bool = false,
        playedTime: TimeInterval = 0,
        recordedFiles: [URL] = [],
        selectedRecordedFile: URL? = nil
    ){
        self.isDisplayRemoveVoiceRecorderAlert = isDisplayRemoveVoiceRecorderAlert
        self.isDisplayAlert = isDisplayAlert
        self.alertMessage = alertMessage
        self.isRecording = isRecording
        self.isPlaying = isPlaying
        self.isPaused = isPaused
        self.playedTime = playedTime
        self.recordedFiles = recordedFiles
        self.selectedRecordedFile = selectedRecordedFile
    }
    
    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        switch audioSession.recordPermission {
        case .undetermined: // 아직 녹음 권한 요청이 되지 않음, 사용자에게 권한 요청
            audioSession.requestRecordPermission({ allowed in
                completion(allowed)
            })
    
        case .denied: // 사용자가 녹음 권한 거부, 사용자가 직접 설정 화면에서 권한 허용을 하게끔 유도
            print("[Failure] Record Permission is Denied.")
            completion(false)
    
        case .granted: // 사용자가 녹음 권한 허용
            print("[Success] Record Permission is Granted.")
            completion(true)
   
        @unknown default:
            fatalError("[ERROR] Record Permission is Unknown Default.")
        }
    }
}

extension VoiceRecorderViewModel {
    func voiceRecordCellTapped(_ recordedFile: URL) {
        if selectedRecordedFile != recordedFile {
            stopPlaying()
            selectedRecordedFile = recordedFile
        }
    }
    
    func removeBtnTapped() {
        setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecordedFile,
              let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }

        do {
            try fileManager.removeItem(at: fileToRemove)
            recordedFiles.remove(at: indexToRemove)
            selectedRecordedFile = nil
            
            stopPlaying()
            
            displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭제했습니다.")
        }
        catch {
            displayAlert(message: "선택된 음성메모 파일 삭제 중 오류가 발생했습니다.")
        }
    }
    
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
        isDisplayRemoveVoiceRecorderAlert = isDisplay
    }
    
    private func setalertMessage(_ message: String) {
        alertMessage = message
    }
    
    private func setisDisplayAlert(_ isDisplay: Bool) {
        isDisplayAlert = isDisplay
    }
    
    private func displayAlert(message: String) {
        setalertMessage(message)
        setisDisplayAlert(true)
    }

}

//MARK: - 음성메모 녹음 관련
extension VoiceRecorderViewModel {
    func recordBtnTapped() {
        selectedRecordedFile = nil
        
        if isPlaying {
            stopPlaying()
            startRecording()
        }
        else if isRecording {
            stopRecording()
        }
        else {
            startRecording()
        }
    }
    
    private func startRecording() {
        
        let directoryURL = getDocumentsDirectory().appending(path: "voiceMemo")

        if fileManager.fileExists(atPath: directoryURL.getFilePath()) == false {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("폴더를 생성하는 중 오류가 발생했습니다: \(error.localizedDescription)")
            }
        }
        
        let fileURL = directoryURL.appending(path: "새로운 녹음\(recordedFiles.count + 1)")//.appendingPathComponent("새로운 녹음\(recordedFiles.count + 1)")
        print(fileURL)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000, // 샘플링 되는 비율
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            self.isRecording = true
        }
        catch {
            displayAlert(message: "음성 메모 녹음 중 오류가 발생했습니다.")
        }
    }
    
    private func stopRecording() {
        if audioRecorder != nil {
            audioRecorder?.stop()
            self.recordedFiles.append(audioRecorder!.url)
            self.isRecording = false
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//MARK: - 음성메모 재생 관련
extension VoiceRecorderViewModel {
    func startPlaying(recordingURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            self.isPlaying = true
            self.isPaused = false
            self.progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                // TODO: - 현재 시각 업데이트 메서드 호출
                
            }
        }
        catch {
            displayAlert(message: "음성 메모 재생 중 오류가 발생헀습니다.")
        }
    }
    
    private func updateCurrentTime() {
        self.playedTime = audioPlayer?.currentTime ?? 0
    }
    
    private func stopPlaying() {
        audioPlayer?.stop()
        playedTime = 0
        self.progressTimer?.invalidate()
        self.isPlaying = false
        self.isPaused = false
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        self.isPlaying = true
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
    func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
        let fileManager = fileManager
        var creationDate: Date?
        var duration: TimeInterval?
        
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
            creationDate = fileAttributes[.creationDate] as? Date
        }
        catch {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                displayAlert(message: "선택된 음성메모 파일 정보을 불러올 수 없습니다.")
            }
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer.duration
        }
        catch {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                displayAlert(message: "선택된 음성메모 파일의 재생 시간을 불러올 수 없습니다.")
            }
            if let index = recordedFiles.firstIndex(of: url) {
                recordedFiles.remove(at: index)
            }
        }
        
        print("creationDate: \(creationDate), duration: \(duration)")
        return (creationDate, duration)
    }
    
}
