//
//  Model.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation

protocol ModelProtocol {
    func loadToDoList() -> [ToDo]
    func loadToDo(identifier: Int) -> ToDo
}
class Model: ModelProtocol {
    var errorData: ToDo = ToDo.init(identifier: -1, toDoTitle: "error", toDoDate: "error", status: Status.completed)
    var dummyToDo1: ToDo = ToDo.init(identifier: 0, toDoTitle: "Coding Test", toDoDate: "2021-04-24", status: Status.completed)
    var dummyToDo2: ToDo = ToDo.init(identifier: 1, toDoTitle: "Anniversary", toDoDate: "2021-04-25", status: Status.completed)
    var dummyToDo3: ToDo = ToDo.init(identifier: 2, toDoTitle: "Hackerthon", toDoDate: "2021-05-02", status: Status.incompleted)
    
    func loadToDo(identifier: Int) -> ToDo {
        let toDoDatabase = [dummyToDo1, dummyToDo2, dummyToDo3]
        return toDoDatabase[identifier]
    }
    func loadToDoList() -> [ToDo] {
        let toDoDatabase = [dummyToDo1, dummyToDo2, dummyToDo3]
        return toDoDatabase
        
    }
}
extension Model {
    static func factory() -> Model {
        return Model()
    }
}
