//
//  APIManager.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation

class APIManager {
    enum APIError: LocalizedError {
        case urlNotSupport
        case noData
        
        var errorDescription: String? {
            switch self {
            case .urlNotSupport:
                return "URL Not Supported"
            case .noData:
                return "Has No Data"
            }
        }
    }
    
    static let shared = APIManager()
    
    private lazy var defaultSession = URLSession(configuration: .default)
    
    private init() { }
    
    internal func signIn(email: String,
                         password: String,
                         completionHandler: @escaping (Result<Bool, APIError>) -> Void) {
        guard let url = URL(string: Config.memberLogin) else {
            completionHandler(.failure(.urlNotSupport))
            return
        }
        
        struct SignInBody: Codable {
            let email, password: String
        }
        
        let param: [String: String] = [
            "email" : email,
            "password" : password
        ]
        let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        let body = SignInBody(email: email, password: password)
       
        var resource = Resource<SignInBody>(url: url, method: .post(body))
        resource.urlRequest.httpBody = sendData
        resource.urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        resource.urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        dump(resource)
        defaultSession.load(resource) { _, isSuccess in
            print(isSuccess)
            isSuccess ? completionHandler(.success(true)) : completionHandler(.failure(.noData))
        }
    }
    
    internal func getTodos(completionHandler: @escaping (Result<[Content], APIError>) -> Void) {
        guard let url = URL(string: Config.contentTodos) else {
            completionHandler(.failure(.urlNotSupport))
            return
        }
        
        let resource = Resource<[Content]>(url: url)
        defaultSession.load(resource) { contents, _ in
            guard let data = contents, !data.isEmpty else {
                completionHandler(.failure(.noData))
                return
            }
            completionHandler(.success(data))
        }
    }

    internal func postTodo(
        title: String,
//        status: Status,
        status: String,
        dueDate: String,
        completionHandler: @escaping (Result<Todo, APIError>) -> Void
    ) {
        
        struct PostBody: Codable {
            var title: String
            var status: String
            var dueDate: String
        }
        
        let body = PostBody(title: title, status: status, dueDate: dueDate)
        
        guard let url = URL(string: Config.contentTodo) else {
            completionHandler(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<Todo>(url: url,
                                      method: .post(body))
        defaultSession.load(resource) { todo, _ in
            guard let data = todo else {
                completionHandler(.failure(.noData))
                return
            }
            completionHandler(.success(data))
        }
    }
    
    internal func putTodoState(
        toDo: Todo,
        completionHandler: @escaping (Result<Todo, APIError>) -> Void
    ) {
        struct PutBody: Codable {
            var title: String
            var status: String
            var dueDate: String
        }
        let body = PutBody(title: toDo.title, status: toDo.status, dueDate: toDo.dueDate)
        
        guard let url = URL(string: Config.contentTodo + "/\(toDo.id)") else {
            completionHandler(.failure(.urlNotSupport))
            return
        }
        
        let resource = Resource<Todo>(url: url,
                                      method: .put(body))
        
        defaultSession.load(resource) { toDo, _ in
            guard let data = toDo else {
                completionHandler(.failure(.noData))
                return
            }
            completionHandler(.success(data))
        }
    }
    
    internal func deleteTodo(
        todo: Todo,
        completionHandler: @escaping (Result<Bool, APIError>) -> Void
    ) {
        guard let url = URL(string: Config.contentTodo + "/\(todo.id)") else {
            completionHandler(.failure(.urlNotSupport))
            return
        }
        
        struct EmptyStruct { }
        
        let resource = Resource<EmptyStruct>(url: url, method: .delete)
        defaultSession.load(resource) { _, isSuccess in
            isSuccess ? completionHandler(.success(true)) : completionHandler(.failure(.noData))
        }
    }
    
    // Example
//    func get1(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
//        guard let url = URL(string: "\(Config.baseURL)/posts") else {
//            completionHandler(.failure(.urlNotSupport))
//            return
//        }
//
//        let resource = Resource<[UserData]>(url: url)
//        defaultSession.load(resource) { userDatas, _ in
//            guard let data = userDatas, !data.isEmpty else {
//                completionHandler(.failure(.noData))
//                return
//            }
//            completionHandler(.success(data))
//        }
//    }
    
//    func get2(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
//        let resource = Resource<[UserData]>(url: "\(Config.baseURL)/posts",
//                                            parameters: ["userId": "1"])
//        defaultSession.load(resource) { userDatas, _ in
//            guard let data = userDatas, !data.isEmpty else {
//                completionHandler(.failure(.noData))
//                return
//            }
//            completionHandler(.success(data))
//        }
//    }
    
//    func post(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
//        guard let url = URL(string: "\(Config.baseURL)/posts") else {
//            completionHandler(.failure(.urlNotSupport))
//            return
//        }
//
//        let userData = PostUserData()
//        let resource = Resource<PostUserData>(url: url,
//                                              method: .post(userData))
//        defaultSession.load(resource) { userData, _ in
//            guard let data = userData else {
//                completionHandler(.failure(.noData))
//                return
//            }
//            completionHandler(.success([data.toUserData()]))
//        }
//    }
//    func put(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
//        guard let url = URL(string: "\(Config.baseURL)/posts/1") else {
//            completionHandler(.failure(.urlNotSupport))
//            return
//        }
//        let userData = PostUserData(id: 1)
//        let resource = Resource<PostUserData>(url: url,
//                                              method: .put(userData))
//        defaultSession.load(resource) { userData, _ in
//            guard let data = userData else {
//                completionHandler(.failure(.noData))
//                return
//            }
//            completionHandler(.success([data.toUserData()]))
//        }
//    }
//    func patch(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
//        guard let url = URL(string: "\(Config.baseURL)/posts/1") else {
//            completionHandler(.failure(.urlNotSupport))
//            return
//        }
//        let userData = PostUserData(id: 1)
//        let resource = Resource<PostUserData>(url: url,
//                                              method: .patch(userData))
//        defaultSession.load(resource) { userData, _ in
//            guard let data = userData else {
//                completionHandler(.failure(.noData))
//                return
//            }
//            completionHandler(.success([data.toUserData()]))
//        }
//    }
    
//    func delete(completionHandler: @escaping (Result<[UserData], APIError>) -> Void) {
//        guard let url = URL(string: "\(Config.baseURL)/posts/1") else {
//            completionHandler(.failure(.urlNotSupport))
//            return
//        }
//        let userData = PostUserData()
//        let resource = Resource<UserData>(url: url,
//                                          method: .delete(userData))
//        defaultSession.load(resource) { userData, response in
//            if response {
//                completionHandler(.success([UserData(userId: -1,
//                                                     id: -1,
//                                                     title: "DELETE",
//                                                     body: "SUCCESS")]))
//            } else {
//                completionHandler(.failure(.noData))
//
//            }
//        }
//    }
}
