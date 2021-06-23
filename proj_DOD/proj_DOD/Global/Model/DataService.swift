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

    private init() { }

    public func createTodo(toDo: Todo) -> Bool {
        return coreDataManager.createNewTodo(toDo: toDo)
    }

    public func updateTodoInfo(at oldTodo: Todo, to newTodo: Todo) -> Bool {
        return coreDataManager.updateTodoInfo(at: oldTodo, to: newTodo)
    }

    public func updateTodoStatus(at toDo: Todo, to status: Status) -> Bool {
        return coreDataManager.updateTodoStatus(at: toDo, to: status)
    }

    public func deleteTodo(toDo: Todo) -> Bool {
        return coreDataManager.setDeleteState(toDo: toDo)
    }
    
    public func getTotalTodoList() -> [Content] {
        
        let toDoList = coreDataManager.fetchAllTodo()
        var dic: [String: [Todo]] = [:]
        
        toDoList.forEach {
            let key = $0.dueDate ?? ""
            let toDo = Todo(id: Int($0.id),
                            memberID: Int($0.memberID),
                            title: $0.title ?? "",
                            status: $0.status ?? "",
                            dueDate: $0.dueDate ?? "")
            
            guard var value = dic[key] else {
                dic.updateValue([toDo], forKey: key)
                return
            }
            value.append(toDo)
            dic.updateValue(value, forKey: key)
        }
        
        return dic.map { return Content(dueDateString: $0.key, todos: $0.value) }
    }
    
    public func getTodoList(at date: Date) -> [Todo] {
        let toDoList = coreDataManager.fetchTodosOfDueDate(by: date.toString())
        var dic: [String: [Todo]] = [:]
        
        toDoList.forEach {
            let key = $0.dueDate ?? ""
            let toDo = Todo(id: Int($0.id),
                            memberID: Int($0.memberID),
                            title: $0.title ?? "",
                            status: $0.status ?? "",
                            dueDate: $0.dueDate ?? "")
            guard var value = dic[key] else {
                dic.updateValue([toDo], forKey: key)
                return
            }
            value.append(toDo)
            dic.updateValue(value, forKey: key)
        }
        
        return toDoList.map { $0.toTodo() }
    }
    
    internal func updateRemoteDB() {
        let toDoLocal = coreDataManager.fetchNonSyncRemoteDB(hasDeleted: false)
        
        toDoLocal.forEach {
            if $0.id == -1 {
                updateRemoteNewTodo(toDoLocal: $0)
            }
            else {
                updateRemoteTodoInfo(toDoLocal: $0)
            }
        }
        
        updateDeletedTodo()
    }
    
    private func updateRemoteNewTodo(toDoLocal: ToDoLocal){
        apiManager.postTodo(title: toDoLocal.title ?? "",
                            status: toDoLocal.status ?? "",
                            dueDate: toDoLocal.dueDate ?? "") { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let toDo):
                strongSelf.coreDataManager.setNewTodoRemoteUpdate(toDo: toDoLocal.toTodo(),
                                                                  id: toDo.id,
                                                                  memberId: toDo.memberID)
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func updateRemoteTodoInfo(toDoLocal: ToDoLocal){
        apiManager.putTodoState(toDo: toDoLocal.toTodo()) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let toDo):
                strongSelf.coreDataManager.setTodoRemoteUpdate(toDo: toDo)
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func updateDeletedTodo() {
        let deletedTodoLocal = coreDataManager.fetchNonSyncRemoteDB(hasDeleted: true)
        
        deletedTodoLocal
            .filter { $0.id != -1 }
            .forEach { toDoLocal in
                apiManager.deleteTodo(todo: toDoLocal.toTodo()) { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.coreDataManager.setTodoRemoteUpdate(toDo: toDoLocal.toTodo())
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
    
    public func getDate(contentList: [Content]) -> [Date] {
        return contentList.map{$0.dueDateString.toDate()}
    }
    
    public func getTodo(toDoList: [Todo], rowAt: Int = 0) -> Todo {
        return toDoList[rowAt]
    }
}
