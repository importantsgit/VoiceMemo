//
//  OnboardingView.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/23.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var todoListViewModel = TodoListViewModel()
    @StateObject private var memoListViewModel = MemoListViewModel()
    
    var body: some View {
        
        NavigationStack(path: $pathModel.paths) {
            OnboardingContentView(onboardingViewModel: onboardingViewModel)
                .navigationDestination(
                    for: PathType.self
                ) { pathType in
                    switch pathType {
                    case .homeView:
                        HomeView()
                            .navigationBarBackButtonHidden() // 커스텀 네비게이션을 사용하기 위해서
                            .environmentObject(todoListViewModel)
                            .environmentObject(memoListViewModel)
                        
                    case .todoView:
                        TodoView()
                            .environmentObject(todoListViewModel)
                            .navigationBarBackButtonHidden()
                        
                        
                    case let .memoView(isCreateMode, memo):
                        MemoView(
                            memoViewModel: isCreateMode
                            ? .init(memo: .init(title: "", content: "", date: .now))
                            : .init(memo: memo ?? .init(title: "", content: "", date: .now)),
                            isCreateMode: isCreateMode
                        )
                        .navigationBarBackButtonHidden()
                        .environmentObject(memoListViewModel)
                    }
                }
        }
        .environmentObject(pathModel) // HomeView같은 view에서 빠져나올 수 있게
    }
}

// MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            Spacer()
            
            StartBtnView()
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
}
// MARK: - 온보딩 셀리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex: Int
    
    fileprivate init(
        onboardingViewModel: OnboardingViewModel,
        selectedIndex: Int = 0
    ) {
        self.onboardingViewModel = onboardingViewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            // 온보딩 셀
            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, onboardingContent in
                OnboardingCellView(onoboardingContent: onboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        .background {
            selectedIndex.isMultiple(of: 2) ? Color.customSky : Color.customGreen
        }
        .clipped()
        
    }
}
// MARK: - 시작하기 버튼 뷰
private struct StartBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        Button {
            pathModel.paths.append(.homeView)
        } label: {
            HStack {
                Text("시작하기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.customGreen)
                
                Image("startHome")
                    .renderingMode(.template)
                    .foregroundColor(.customGreen)
            }
        }
        .padding(.bottom, 50)

    }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    private var onoboardingContent: OnboardingContent
    
    fileprivate init(onoboardingContent: OnboardingContent) {
        self.onoboardingContent = onoboardingContent
    }
    
    fileprivate var body: some View {
        VStack {
            Image(onoboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
            
            HStack {
                Spacer()
                
                VStack() {
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onoboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(onoboardingContent.subTitle)
                        .font(.system(size: 16))
                }
                    Spacer()
            }
            .background(Color.customWhite)
            .cornerRadius(0)
        }
        .shadow(radius: 10)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
