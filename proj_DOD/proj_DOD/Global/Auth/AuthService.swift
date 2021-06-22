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
    public var isUserSignedIn: Bool {
        let value: Bool = UserDefaults.standard.bool(forKey: "isUserSignedIn")
        return value
    }
    public var memberId: Int {
        let value:Int = UserDefaults.standard.integer(forKey: "mid")
        return value
    }
    
    private init() { }
    
    internal func requestSignIn() { }
    
    internal func requestSignUp() { }
    
    
}
