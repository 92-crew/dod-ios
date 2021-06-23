//
//  DataService.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/05/30.
//

import Foundation




internal class DataService {
    internal static let shared = DataService()

    private let coreDataManager: CoreDataManager = CoreDataManager.shared
    private let apiManager: APIManager = APIManager.shared

    private var isUserSignedIn: Bool {
        let value: Bool = UserDefaults.standard.bool(forKey: "isUserSignedIn")

        return value
    }

    private init() { }

    public func createTodo(toDo: Todo) -> Bool {
//        let isSuccess = coreDataManager.createNewTodo(toDo: toDo)
//
//        if isUserSignedIn && isSuccess {
//            apiManager.postTodo(title: toDo.title,
//                                status: toDo.status,
//                                dueDate: toDo.dueDate) { result in
//                print(result)
//            }
//        }

        return true
    }

    public func updateTodoInfo(at oldTodo: Todo, to newTodo: Todo) -> Bool {
//        let isSuccess = coreDataManager.updateTodoInfo(at: oldTodo, to: newTodo)
//
//        if isUserSignedIn && isSuccess {
//            apiManager.putTodoState(toDo: newTodo) { result in
//                print(result)
//            }
//        }

        return true
    }

    public func updateTodoStatus(at toDo: Todo, to status: Status) -> Bool {
//        let isSuccess = coreDataManager.updateTodoStatus(at: toDo, to: status)
//
//        if isUserSignedIn && isSuccess {
//            let newStatusTodo = Todo(id: toDo.id,
//                                     memberID: toDo.memberID,
//                                     title: toDo.title,
//                                     status: status.statusMessage,
//                                     dueDate: toDo.dueDate)
//            apiManager.putTodoState(toDo: newStatusTodo) { result in
//                print(result)
//            }
//        }

        return true
    }

    public func deleteTodo(toDo: Todo) -> Bool {
        if isUserSignedIn {

        }
        else {

        }
        
        return true
    }
    
    public func getTotalTodoList() -> [Content] {
        
    }
    
    public func getTodoList(at date: Date) -> [Todo] {
        
        return []
    }
    
    public func getDate(contentList: [Content]) -> [Date] {
        return contentList.map{$0.dueDateString.toDate()}
    }
    
    public func getTodo(toDoList: [Todo], rowAt: Int = 0) -> Todo {
        return toDoList[rowAt]
    }
}
