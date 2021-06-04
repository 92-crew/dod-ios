//
//  Resource.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/14.
//

import Foundation


struct Resource<T> {
    var urlRequest: URLRequest
    let parse: (Data) -> T?
    
    // Body Non Needed
    init(url: URL, method: HttpMethod<T>) {
        self.urlRequest = URLRequest(url: url)
        self.urlRequest.httpMethod = method.method
        
        self.parse = { _ in return nil }
    }
}

extension Resource where T: Decodable {
    init(url: URL) {
        self.urlRequest = URLRequest(url: url)
        self.parse = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }
    
    init(url: String, parameter _parameters: [String:String]) {
        var component = URLComponents(string: url)
        var parameters = [URLQueryItem]()
        for (name, value) in _parameters {
            if name.isEmpty { continue }
            parameters.append(URLQueryItem(name: name, value: value))
        }
        
        if !parameters.isEmpty {
            component?.queryItems = parameters
        }
        
        if let componentURL = component?.url {
            self.urlRequest = URLRequest(url: componentURL)
        }
        else {
            self.urlRequest = URLRequest(url: URL(string: url)!)
        }
        self.parse = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }
    
    init<Body: Encodable>(url: URL, method: HttpMethod<Body>) {
        self.urlRequest = URLRequest(url: url)
        self.urlRequest.httpMethod = method.method
        switch method {
        case .post(let body), .patch(let body), .put(let body):
            guard let jsonData = try? JSONEncoder().encode(body) else {
                print("Error: Trying to convert model to JSON data")
                self.parse = { data in
                    try? JSONDecoder().decode(T.self, from: data)
                }
                return
            }
            
            self.urlRequest.httpBody = jsonData
            self.urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            self.urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        default:
            break
        }
        self.parse = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }
}
