//
//  MainViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation
class TotalToDoViewModel {
    var toDo: Todo
    private var dataService = DataService.shared
    private var contentList: [Content]
    private var toDoList: [Todo]
    var date: Date
    init(dataService: DataService) {
//        for i in 0..<contentList.count{
//            date = contentList[i].dueDateString.toDate()
//        }
        self.dataService = dataService
        self.contentList = self.dataService.getTotalTodoList()
        self.toDoList = self.dataService.getTodoList(at: self.date)
        
    }
    
    
}

extension TotalToDoViewModel {
    var contentCount: Int {
        return self.contentList.count
    }
    var toDoDateInSection: [String] {
        return self.contentList.map{$0.dueDateString}
    }
    var toDoTitle: [String] {
        return self.toDoList.map{$0.title}
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
