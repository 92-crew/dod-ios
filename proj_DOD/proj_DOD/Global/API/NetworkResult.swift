//
//  NetworkResult.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/14.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
