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

    @discardableResult
    public func createTodo(toDo: Todo) -> Bool {
        return coreDataManager.createNewTodo(toDo: toDo)
    }

    @discardableResult
    public func updateTodoInfo(at oldTodo: Todo, to newTodo: Todo) -> Bool {
        return coreDataManager.updateTodoInfo(at: oldTodo, to: newTodo)
    }

    @discardableResult
    public func updateTodoStatus(at toDo: Todo, to status: Status) -> Bool {
        return coreDataManager.updateTodoStatus(at: toDo, to: status)
    }

    @discardableResult
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
                            dueDate: $0.dueDate ?? "",
                            createdAt: $0.createdAt)
            
            guard var value = dic[key] else {
                dic.updateValue([toDo], forKey: key)
                return
            }
            value.append(toDo)
            dic.updateValue(value, forKey: key)
        }
        
        return dic.map {
            let values = $0.value.sorted { (todo1, todo2) in
                return todo1.id < todo2.id
            }
            return Content(dueDateString: $0.key, todos: values) }
            .sorted { return $0.dueDateString.toDate() > $1.dueDateString.toDate() }
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
                            dueDate: $0.dueDate ?? "",
                            createdAt: $0.createdAt)
            
            guard var value = dic[key] else {
                dic.updateValue([toDo], forKey: key)
                return
            }
            value.append(toDo)
            dic.updateValue(value, forKey: key)
        }
        
        return toDoList
            .map { $0.toTodo() }
            .sorted { $0.id > $1.id }
    }
    
    internal func fetchRemoteDB(completion: @escaping () -> Void) {
        if !AuthService.shared.isUserSignedIn { completion(); return }
        
        apiManager.getTodos { result in
            switch result {
            case .success(let data):
                guard let toDoResult = data as? ToDoResult else { return }
                var toDos: [Todo] = []
                toDoResult.contents.forEach { toDos.append(contentsOf: $0.todos) }
                DispatchQueue.main.async {
                    if self.coreDataManager.deleteAlreadyUpdatedData() {
                        self.coreDataManager.updateLocalData(by: toDos)
                    }
                    completion()
                }
                return
            case .requestErr(let data):
                guard let error = data as? ErrorResult else { return }
                print(error.message)
            case .pathErr:
                print("\(#function) pathErr")
            case .serverErr:
                print("\(#function) serverErr")
            case .networkFail:
                print("\(#function) networkFail")
            }
            completion()
        }
    }
    
    internal func synchronizeDB(completion: @escaping (Bool) -> Void) {
        updateRemoteDB { [unowned self] in
            if $0.filter({ !$0 }).count == 0 {
                self.fetchRemoteDB {
                    completion(true)
                }
            }
            else {
                completion(false)
            }
        }
    }
    
    internal func updateRemoteDB(completion: @escaping ([Bool]) -> Void) {
        if !AuthService.shared.isUserSignedIn { completion([true]); return }
        
        let toDoLocal = coreDataManager.fetchNonSyncRemoteDB(hasDeleted: false)
        var result = [Bool](repeating: false, count: toDoLocal.count)
        toDoLocal.enumerated().forEach { (i, todoLocal) in
            if todoLocal.id == -1 {
                updateRemoteNewTodo(toDoLocal: todoLocal) {
                    result[i] = $0
                    completion(result)
                }
            }
            else {
                updateRemoteTodoInfo(toDoLocal: todoLocal) {
                    result[i] = $0
                    completion(result)
                }
            }
        }
        
        updateDeletedTodo()
        completion(result)
    }
    
    private func updateRemoteNewTodo(toDoLocal: ToDoLocal, completion: @escaping (Bool) -> Void){
        apiManager.postTodo(title: toDoLocal.title ?? "",
                            status: toDoLocal.status ?? "",
                            dueDate: toDoLocal.dueDate ?? "") { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                guard let toDo = data as? Todo else { return }
                let result = strongSelf.coreDataManager.setNewTodoRemoteUpdate(toDo: toDoLocal.toTodo(),
                                                                               id: toDo.id,
                                                                               memberId: toDo.memberID)
                completion(result)
            case .requestErr(let data):
                guard let error = data as? ErrorResult else { return }
                print(error.message)
                completion(false)
            case .pathErr:
                print("\(#function) pathErr")
                completion(false)
            case .serverErr:
                print("\(#function) serverErr")
                completion(false)
            case .networkFail:
                print("\(#function) networkFail")
                completion(false)
            }
        }
    }
    
    private func updateRemoteTodoInfo(toDoLocal: ToDoLocal, completion: @escaping (Bool) -> Void){
        apiManager.putTodoState(toDo: toDoLocal.toTodo()) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                guard let toDo = data as? Todo else { return }
                let result = strongSelf.coreDataManager.setTodoRemoteUpdate(toDo: toDo)
                completion(result)
            case .requestErr(let data):
                guard let error = data as? ErrorResult else { return }
                print(error.message)
                completion(false)
            case .pathErr:
                print("\(#function) pathErr")
                completion(false)
            case .serverErr:
                print("\(#function) serverErr")
                completion(false)
            case .networkFail:
                print("\(#function) networkFail")
                completion(false)
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
                    case .requestErr(let data):
                        guard let error = data as? ErrorResult else { return }
                        print(error.message)
                    case .pathErr:
                        print("\(#function) pathErr")
                    case .serverErr:
                        print("\(#function) serverErr")
                    case .networkFail:
                        print("\(#function) networkFail")
                    }
                }
        }
    }
    public func getDate(contentList: [Content]) -> [Date] {
        return contentList.map{$0.dueDateString.toDate()}
    }
    
    public func getTodo(toDoList: [Todo], rowAt: Int = 0) -> Todo {
        if toDoList.isEmpty {
            return .init(id: -1, memberID: -1, title: "Error", status: "UNRESOLVED", dueDate: "2021-01-01")
        } else {
            return toDoList[rowAt]
        }
    }
}
