//
//  TodoListViewModel.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/28.
//

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var isEditTodoMode: Bool
    @Published var removeTodos: [Todo]
    @Published var isDisplayRemoveAlert: Bool
    
    var romoveTodosCount: Int {
        return removeTodos.count
    }
    
    var navigationBarRightBtnMode: NavigationBtnType {
        isEditTodoMode == true ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        isEditTodoMode: Bool = false,
        removeTodos: [Todo] = [],
        isDisplayRemoveAlert: Bool = false
    ) {
        self.todos = todos
        self.isEditTodoMode = isEditTodoMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveAlert = isDisplayRemoveAlert
    }
}

extension TodoListViewModel {
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].selected.toggle()
        }
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func navigationRightBtnTapped() {
        if isEditTodoMode {
            if removeTodos.isEmpty == true {
                isEditTodoMode = false
            }
            else {
                setIsDisplayRemoveTodoAlert(true)
            }
        }
        else {
            isEditTodoMode = true
        }
    }
    
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveAlert = isDisplay
    }
    
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        if let index = removeTodos.firstIndex(of: todo) {
            removeTodos.remove(at: index)
        }
        else {
            removeTodos.append(todo)
        }
    }
    
    func removeBtnTapped() {
        todos.removeAll { todo in
            removeTodos.contains(todo)
        }
        
        removeTodos.removeAll()
        isEditTodoMode = false
    }
}
