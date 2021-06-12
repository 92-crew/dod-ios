//
//  MainViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation
class TotalToDoViewModel {
    private var toDoService: ToDoServiceProtocol
    var toDo: Todo
    private var dataService = DataService.shared
//    private var toDo: Todo
    private var toDoList: [Todo]
    init(toDoService: ToDoServiceProtocol) {
        self.toDoService = toDoService
        self.toDoList = self.toDoService.loadToDoList()
        self.toDo = self.toDoService.loadToDo(identifier: 0)
    
    }
    
    
}

extension TotalToDoViewModel {
    var toDoCount: Int {
        return self.toDoList.count
    }
    var toDoDateInSection: [String] {
        return self.toDoList.map{$0.dueDate}
    }
    func cellViewModels(row: Int) -> TotalToDoCellViewModel {
        return TotalToDoCellViewModel(toDoService: self.toDoService as! ToDoService, toDoIdentifier: toDoList[row].id)
    }
    var toDoArr: [Todo] {
        return self.toDoList
    }
    
}

//extension TotalToDoViewModel {
//    var toDoTitle: String {
//        toDo.toDoTitle
//    }
//    var toDoDate: String {
//        toDo.toDoDate
//    }
//    var status: Status {
//        toDo.status
//    }
//}
