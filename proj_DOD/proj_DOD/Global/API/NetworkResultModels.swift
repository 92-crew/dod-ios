//
//  NetworkResultModels.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/06/22.
//

import Foundation

struct SignInResult: Codable {
    let id: Int
    let email, password: String
}
// MARK: - ResponseTodo
struct ToDoResult: Codable {
    let contents: [Content]
}

struct ErrorResult: Codable {
    let status: Int
    let error: String
    let message: String
}
