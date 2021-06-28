//
//  APIManager.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation

import RxSwift

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
    
    internal func signIn(
        email: String,
        password: String,
        completionHandler: @escaping (NetworkResult<Any>) -> Void
    ) {
        guard let url = URL(string: Config.memberLogin) else {
            completionHandler(.pathErr)
            return
        }
        
        let body: [String: Any] = [
            "email" : email,
            "password" : password
        ]
        
        let resource = Resource(url: url, parameter: body, method: .post)
        
        defaultSession.load(resource) { [weak self] networkResult in
            guard let strongSelf = self else {
                completionHandler(.pathErr)
                return
            }
            completionHandler(strongSelf.translateData(networkResult: networkResult, type: SignInResult.self))
        }
    }
    
    internal func getTodos(completionHandler: @escaping (NetworkResult<Any>) -> Void) {
        guard let url = URL(string: Config.contentTodos) else {
            completionHandler(.pathErr)
            return
        }
        
        let resource = Resource(url: url, memberId: AuthService.shared.memberId, method: .get)
        defaultSession.load(resource) { [weak self] networkResult in
            guard let strongSelf = self else {
                completionHandler(.pathErr)
                return
            }
            completionHandler(strongSelf.translateData(networkResult: networkResult, type: ToDoResult.self))
        }
    }

    internal func postTodo(
        title: String,
        status: String,
        dueDate: String,
        completionHandler: @escaping (NetworkResult<Any>) -> Void
    ) {
        
        guard let url = URL(string: Config.contentTodo) else {
            completionHandler(.pathErr)
            return
        }
        let parameter: [String: Any] = [
            "dueDate": dueDate,
            "status": status,
            "title": title
        ]
        let resource = Resource(url: url,
                                memberId: AuthService.shared.memberId,
                                parameter: parameter,
                                method: .post)
        
        defaultSession.load(resource) { [weak self] networkResult in
            guard let strongSelf = self else {
                completionHandler(.pathErr)
                return
            }
            completionHandler(strongSelf.translateData(networkResult: networkResult, type: Todo.self))
        }
    }
    
    internal func putTodoState(
        toDo: Todo,
        completionHandler: @escaping (NetworkResult<Any>) -> Void
    ) {
        guard let url = URL(string: Config.contentTodo) else {
            completionHandler(.pathErr)
            return
        }
        let parameter: [String: Any] = [
            "dueDate": toDo.dueDate,
            "id": toDo.id,
            "status": toDo.status,
            "title": toDo.title
        ]
        
        let resource = Resource(url: url,
                                memberId: AuthService.shared.memberId,
                                parameter: parameter,
                                method: .put)
        
        defaultSession.load(resource) { [weak self] networkResult in
            guard let strongSelf = self else {
                completionHandler(.pathErr)
                return
            }
            completionHandler(strongSelf.translateData(networkResult: networkResult, type: Todo.self))
        }
    }
    
    internal func deleteTodo(
        todo: Todo,
        completionHandler: @escaping (NetworkResult<Any>) -> Void
    ) {
        let requestURL = Config.contentTodo + "/\(todo.id)"
        guard let url = URL(string: requestURL) else {
            completionHandler(.pathErr)
            return
        }
        
        let resource = Resource(url: url,
                                memberId: AuthService.shared.memberId,
                                method: .delete)
        defaultSession.load(resource) { [weak self] networkResult in
            guard let strongSelf = self else {
                completionHandler(.pathErr)
                return
            }
            completionHandler(strongSelf.getResult(networkResult: networkResult))
        }
    }
    
    func translateData<T: Decodable>(networkResult: NetworkResult<Data?>, type: T.Type) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        switch networkResult {
        case .success(let data):
            guard
                let unwrappingData = data,
                let result = try? decoder.decode(T.self, from: unwrappingData)
            else {
                return .pathErr
            }
            return .success(result)
        case .requestErr(let data):
            guard
                let unwrappingData = data,
                let errorResult = try? decoder.decode(ErrorResult.self, from: unwrappingData)
            else {
                return .pathErr
            }
            return .requestErr(errorResult)
        case .pathErr:
            return .pathErr
        case .serverErr:
            return .serverErr
        case .networkFail:
            return .networkFail
        }
    }
    
    func getResult(networkResult: NetworkResult<Data?>) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        switch networkResult {
        case .success(_):
            return .success(true)
        case .requestErr(let data):
            guard
                let unwrappingData = data,
                let errorResult = try? decoder.decode(ErrorResult.self, from: unwrappingData)
            else {
                return .pathErr
                
            }
            return .requestErr(errorResult)
        case .pathErr:
            return .pathErr
        case .serverErr:
            return .serverErr
        case .networkFail:
            return .networkFail
        }
    }
}
