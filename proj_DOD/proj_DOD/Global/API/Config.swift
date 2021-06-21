//
//  Config.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/13.
//

import Foundation


struct Config {
    static let baseURL = "http://ec2-18-117-246-33.us-east-2.compute.amazonaws.com"
    static let contentTodos = "/api/content/v1/todos"
    static let contentTodo = "/api/content/v1/todo"
    static let memberLogin = baseURL + "/api/v1/member/login"
}
