//
//  HttpMethod.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/13.
//

import Foundation

enum HttpMethod {
    case get
    case post
    case put
    case patch
    case delete
    
}
extension HttpMethod {
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
