//
//  AuthService.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/06/20.
//

import Foundation


internal class AuthService {
    static let shared = AuthService()
    
    private let apiManager: APIManager = APIManager.shared
    private var isUserSignedIn: Bool {
        let value: Bool = UserDefaults.standard.bool(forKey: "isUserSignedIn")
        return value
    }
    
    private init() { }
    
    internal func requestSignIn() { }
    
    internal func requestSignUp() { }
}
