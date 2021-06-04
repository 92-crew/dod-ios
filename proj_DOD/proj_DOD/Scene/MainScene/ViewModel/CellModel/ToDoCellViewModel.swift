//
//  ToDoCellViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/05/02.
//

import Foundation

class ToDoCellViewModel {
    var toDo: Todo
    internal var toDoService: ToDoServiceProtocol
    init(toDoService: ToDoService, toDoIdentifier: Int) {
        self.toDoService = toDoService
        self.toDo = toDoService.loadToDo(identifier: toDoIdentifier)
    }
}
extension ToDoCellViewModel {
    var toDoTitle: String {
        toDo.title
    }
    var toDoDate: String {
        toDo.dueDate
    }
    var status: String {
        toDo.status
    }
}
