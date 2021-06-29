//
//  Config.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/13.
//

import Foundation

struct Config {
    static let baseURL = "http://ec2-18-117-247-89.us-east-2.compute.amazonaws.com"
    static let memberURL = baseURL + ":8080"
    static let contentURL = baseURL + ":8081"
    
    static let contentTodos = contentURL + "/api/v1/content/todos"
    static let contentTodo = contentURL + "/api/v1/content/todo"
    
    static let memberLogin = memberURL + "/api/v1/member/login"
    static let memberJoin = memberURL + "/api/v1/member/join"
}
