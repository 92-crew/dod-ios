//
//  MainViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation
class TotalToDoViewModel {
    private var dataService = DataService.shared
    var contentList: [Content]
    var date: Date
    var dateList: [Date]
    var index: Int = 0
    init(dataService: DataService) {
        
        self.dataService = dataService
        self.contentList = self.dataService.getTotalTodoList()
        self.dateList = contentList.map{$0.dueDateString}.map{$0.toDate()}
        if dateList.isEmpty {
            let tmp = "2021-01-01"
            self.dateList.append(tmp.toDate())
        } else {
            self.dateList = contentList.map{$0.dueDateString}.map{$0.toDate()}
        }
        self.date = dateList[index]
    }
    func refreshContentList() {
        self.contentList = self.dataService.getTotalTodoList()
    }
    
}

extension TotalToDoViewModel {
    var contentCount: Int {
        return self.contentList.count
    }
    var toDoDateInSection: [String] {
        return self.contentList.map{$0.dueDateString}
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
