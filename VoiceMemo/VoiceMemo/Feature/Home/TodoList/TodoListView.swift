//
//  TodoListView.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/28.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    var body: some View {
        ZStack {
            // 투두 셀 리스트
            VStack {
                if todoListViewModel.todos.isEmpty == false {
                    CustomNavigationBar(
                        isDisplayLeftBtn: false,
                        rightBtnAction: {
                            todoListViewModel.navigationRightBtnTapped()
                        },
                        rightBtnType: todoListViewModel.navigationBarRightBtnMode
                        
                    )
                }
                else {
                    Spacer()
                        .frame(height: 30)
                }
                
                TitleView()
                
                if todoListViewModel.todos.isEmpty {
                    AnnouncementView()
                }
                else {
                    TodoListContentView()
                        .padding(.top, 20)
                    
                }
            }
            
            WriteTodoBtnView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert( "To do list \(todoListViewModel.romoveTodosCount)개 삭제하시겠습니까?",
                isPresented: $todoListViewModel.isDisplayRemoveAlert) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeBtnTapped()
            }
            
            Button("취소", role: .cancel) {}
        }
    }
    
    
    // MARK: - 컴포넌트를 가져오는 방법
    // 1. 변수
    var titleView: some View {
        Text("Title")
    }
    
    // 2. 함수
    func getTitleView() -> some View {
        Text("Title")
    }
}

// 3. 따로 빼서 사용
// MARK: - TodoList 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do list를\n추가해 보세요.")
            }
            else {
                Text("To do list \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TODOList 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template)
            
            Text("\"매일 아침 5시 운동하자!\"")
            Text("\"내일 8시 수강 신처하자!\"")
            Text("\"1시 반 점심 약속 리마인드 해보자!\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }

}

// MARK: - TODOList 컨텐츠 뷰
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        // TODO: - Todo 셀 뷰 todo 넣어서 뷰 호출
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
    }
}


//MARK: - Todo 셀 뷰
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditTodoMode {
                    Button {
                        todoListViewModel.selectedBoxTapped(todo)
                    } label: {
                        Image(todo.selected ? "selectedBox" : "unSelectedBox")
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundColor(todo.selected ? .customIconGray : .customBlack)
                        .strikethrough(todo.selected)
                    
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundColor(.customIconGray)
                    
                }
                
                Spacer()
                
                if todoListViewModel.isEditTodoMode {
                    Button {
                        isRemoveSelected.toggle()
                        todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                    } label: {
                        Image(isRemoveSelected ? "check" : "unCheck")
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - TODO 작성 버튼 뷰
private struct WriteTodoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    pathModel.paths.append(.todoView)
                } label: {
                    Image("write_btn")
                }

            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environmentObject(PathModel())
            .environmentObject(TodoListViewModel())
    }
}
