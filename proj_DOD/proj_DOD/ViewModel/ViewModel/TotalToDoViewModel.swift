//
//  MainViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation
class TotalToDoViewModel {
    private var toDoService: ToDoServiceProtocol
    private var toDoList: [ToDo]
    init(toDoService: ToDoServiceProtocol) {
        self.toDoService = toDoService
        self.toDoList = self.toDoService.loadToDoList()
    }
    
}

extension TotalToDoViewModel {
    func cellViewModels(row: Int) -> TotalToDoCellViewModel {
        return TotalToDoCellViewModel(toDoService: self.toDoService as! ToDoService, toDoIdentifier: toDoList[row].identifier)
    }
}
