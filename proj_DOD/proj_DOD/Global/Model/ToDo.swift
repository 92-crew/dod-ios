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


// MARK: - ResponseTodo
struct ResponseTodo: Codable {
    let contents: [Content]
}

extension ResponseTodo {

}

// MARK: - Content
struct Content: Codable {
    let dueDateString: String
    let todos: [Todo]
}
extension Content {
    
}

// MARK: - Todo
struct Todo: Codable {
    let id, memberID: Int
    let title, status, dueDate: String

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "memberId"
        case title, status, dueDate
    }
}

