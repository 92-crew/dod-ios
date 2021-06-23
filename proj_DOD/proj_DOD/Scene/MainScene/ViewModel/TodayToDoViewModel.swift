//
//  TodayToDoViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/21.
//

import Foundation
class TodayToDoViewModel {
    private var dataService = DataService.shared
    var toDoList: [Todo]
    var date: Date = Date()
    init(dataService: DataService) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let str = formatter.string(from: date)
        date = str.toDate()
        self.dataService = dataService
        self.toDoList = self.dataService.getTodoList(at: date)
    }
    
}

extension TodayToDoViewModel {
    var toDoArr: [Todo] {
        return self.toDoList
    }
    var toDoTitle: [String] {
        return self.toDoList.map{$0.title}
    }
}

