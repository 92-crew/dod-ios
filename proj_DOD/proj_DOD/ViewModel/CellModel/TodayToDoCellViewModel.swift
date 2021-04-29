//
//  TodayToDoCellViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/21.
//

import Foundation
class TodayToDoCellViewModel: ToDoCellViewModel {
    private var toDoService: ToDoServiceProtocol
    private var toDo: ToDo
    override init(toDoService: ToDoService, toDoIdentifier: Int) {
        self.toDoService = toDoService
        self.toDo = toDoService.loadToDo(identifier: toDoIdentifier)
        super.init(toDoService: toDoService, toDoIdentifier: toDoIdentifier)
    }
    
}
