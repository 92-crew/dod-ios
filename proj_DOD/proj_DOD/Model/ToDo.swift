//
//  ToDo.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation
enum Status: Int {
    case completed = 0
    case incompleted = 1
}
struct ToDo {
    var identifier: Int
    var toDoTitle: String
    var toDoDate: String
    var status: Status
}
