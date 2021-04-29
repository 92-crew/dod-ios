//
//  ToDoCellViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/28.
//

import Foundation
class ToDoCellViewModel {
    private var toDoService: ToDoServiceProtocol
    private var toDo: ToDo
    init(toDoService: ToDoService, toDoIdentifier: Int) {
        self.toDoService = toDoService
        self.toDo = toDoService.loadToDo(identifier: toDoIdentifier)
    }
}
extension ToDoCellViewModel {
    var toDoTitle: String {
        self.toDo.toDoTitle
    }
    var toDoDate: String {
        self.toDo.toDoDate
    }
    var status: Status {
        self.toDo.status
    }
}
