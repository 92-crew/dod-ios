//
//  ToDoService.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation

protocol ToDoServiceProtocol {
    func loadToDoList() -> [Todo]
    func loadToDo(identifier: Int) -> Todo
}
class ToDoService: ToDoServiceProtocol {
    
    var dummyToDo1: Todo = Todo.init(id: 0, memberID: 0, title: "Coding Test", status: "RESOLVED", dueDate: "2021-04-24")
    var dummyToDo2: Todo = Todo.init(id: 1, memberID: 0, title: "Birthday", status: "RESOLVED", dueDate: "2021-04-25")
    var dummyToDo3: Todo = Todo.init(id: 2, memberID: 0, title: "Hackerthon", status: "UNRESOLVED", dueDate: "2021-05-02")
    var dummyToDo4: Todo = Todo.init(id: 3, memberID: 0, title: "Coffee", status: "UNRESOLVED", dueDate: "2021-05-02")
    func loadToDo(identifier: Int) -> Todo {
        var sameDate: [Todo] = []
        let toDoDatabase = [dummyToDo1, dummyToDo2, dummyToDo3, dummyToDo4]
        
        return toDoDatabase[identifier]
    }
    func loadToDoList() -> [Todo] {
        let toDoDatabase = [dummyToDo1, dummyToDo2, dummyToDo3, dummyToDo4]
        return toDoDatabase
        
    }
}
extension ToDoService {
    static func factory() -> ToDoService {
        return ToDoService()
    }
}
