//
//  ToDo.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation
enum Status: Int {
    case RESOLVED = 0
    case UNRESOLVED = 1
    
    var statusMessage: String {
        switch self {
        case .RESOLVED:
            return "RESOLVED"
        case .UNRESOLVED:
            return "UNRESOLVED"
        }
    }
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
    let id: Int
    let memberID: Int
    let title, status, dueDate: String
    var createdAt: String? = "\(Date().toCreatedAtString)"

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "memberId"
        case title, status, dueDate
    }
}

