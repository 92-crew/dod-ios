//
//  MainTableViewCellModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation
class MainCellViewModel {
    private var toDo: ToDo
    init(toDo: ToDo) {
        self.toDo = toDo
    }
}
extension MainCellViewModel {
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
