//
//  URL+Extensions.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/12/22.
//

import Foundation

extension URL {
    //MARK: FilePath를 반환하는 함수
    func getFilePath() -> String {
        if #available(iOS 16.0, *) {
            return self.path(percentEncoded: true)
        } else {
            return self.path
        }
    }
}
