//
//  MainTableViewCellModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation
class TotalToDoCellViewModel: ToDoCellViewModel{
    private var toDoService: ToDoServiceProtocol
    private var toDo: ToDo
    override init(toDoService: ToDoService, toDoIdentifier: Int) {
        self.toDoService = toDoService
        self.toDo = toDoService.loadToDo(identifier: toDoIdentifier)
        super.init(toDoService: toDoService, toDoIdentifier: toDoIdentifier)
    }
}

extension Date {
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
         return Calendar.current.component(.day, from: self)
    }
    
    public var monthName: String {
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM" // format January, February, March, ...
        return nameFormatter.string(from: self)
    }
}
