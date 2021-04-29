//
//  TodayToDoViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/21.
//

import Foundation
class TodayToDoViewModel {
    private var toDoService: ToDoServiceProtocol
    private var toDo: ToDo
    init(toDoService: ToDoServiceProtocol) {
        self.toDoService = toDoService
        self.toDo = self.toDoService.loadToDo(identifier: 0)
    }
    
}

extension TodayToDoViewModel {
    func cellViewModels(row: Int) -> TodayToDoCellViewModel {
        return TodayToDoCellViewModel(toDoService: self.toDoService as! ToDoService, toDoIdentifier: 0)
    }
}
