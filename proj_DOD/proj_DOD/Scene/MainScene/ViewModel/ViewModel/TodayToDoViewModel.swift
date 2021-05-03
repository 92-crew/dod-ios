//
//  TodayToDoViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/21.
//

import Foundation
class TodayToDoViewModel {
    private var toDoService: ToDoServiceProtocol
    private var toDo: Todo
    private var toDoList: [Todo]
    init(toDoService: ToDoServiceProtocol) {
        self.toDoService = toDoService
        self.toDo = self.toDoService.loadToDo(identifier: 0)
        self.toDoList = self.toDoService.loadToDoList()
    }
    
}

extension TodayToDoViewModel {
    func cellViewModels(row: Int) -> TodayToDoCellViewModel {
        return TodayToDoCellViewModel(toDoService: self.toDoService as! ToDoService, toDoIdentifier: 0)
    }
    var toDoArr: [Todo] {
        return self.toDoList
    }
}

