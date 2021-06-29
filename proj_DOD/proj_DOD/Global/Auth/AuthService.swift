//
//  AuthService.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/06/20.
//

import Foundation

import RxSwift

internal class AuthService {
    static let shared = AuthService()
    
    private let apiManager: APIManager = APIManager.shared
    private let isUserSignedInKey: String = "isUserSignedIn"
    private let midKey: String = "mid"
    
    public var isUserSignedIn: Bool {
        let value: Bool = UserDefaults.standard.bool(forKey: isUserSignedInKey)
        return value
    }
    public var memberId: Int {
        let value:Int = UserDefaults.standard.integer(forKey: midKey)
        return value
    }
    
    private init() { }
    
    internal func requestSignIn(email: String, password: String) -> Observable<NetworkResult<Any>> {
        guard let url = URL(string: Config.memberLogin) else {
            return Observable.just(.pathErr)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.post.method
        
        let body: [String: Any] = [
            "email" : email,
            "password" : password
        ]
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { (response, data) in
                switch response.statusCode {
                case 200:
                    guard let signInResult = try? JSONDecoder().decode(SignInResult.self, from: data) else {
                        return .pathErr
                    }
                    return .success(signInResult)
                default:
                    guard let errorResult = try? JSONDecoder().decode(ErrorResult.self, from: data) else {
                        return .pathErr
                    }
                    return .requestErr(errorResult)
                }
            }
    }
    
    internal func requestSignUp(email: String, name: String, password: String) -> Observable<NetworkResult<Any>> {
        guard let url = URL(string: Config.memberJoin) else {
            return Observable.just(.pathErr)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.post.method
        
        let body: [String: Any] = [
            "email" : email,
            "name" : name,
            "password" : password
        ]
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { (response, data) in
                switch response.statusCode {
                case 200:
                    guard let signInResult = try? JSONDecoder().decode(SignInResult.self, from: data) else {
                        return .pathErr
                    }
                    return .success(signInResult)
                default:
                    guard let errorResult = try? JSONDecoder().decode(ErrorResult.self, from: data) else {
                        return .pathErr
                    }
                    return .requestErr(errorResult)
                }
            }
    }
    
    internal func loginSuccessHandler(memberId: Int) {
        if self.memberId != memberId {
            CoreDataManager.shared.deleteAll()
        }
        UserDefaults.standard.setValue(memberId, forKey: midKey)
        UserDefaults.standard.setValue(true, forKey: isUserSignedInKey)
    }
    
    internal func logoutHandler() {
        UserDefaults.standard.setValue(nil, forKey: midKey)
        UserDefaults.standard.setValue(false, forKey: isUserSignedInKey)
    }
    
}
