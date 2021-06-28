//
//  Resource.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/14.
//

import Foundation



struct Resource {
    var urlRequest: URLRequest
    
    // Body Non Needed
    init(url: URL, memberId: Int? = nil, parameter: [String: Any]? = nil ,method: HttpMethod) {
        self.urlRequest = URLRequest(url: url)
        self.urlRequest.httpMethod = method.method
        
        if let unwrappingParameter = parameter,
           let serializingData = try? JSONSerialization.data(withJSONObject: unwrappingParameter, options: []) {
            self.urlRequest.httpBody = serializingData
        }
        if let mid = memberId {
            self.urlRequest.addValue("\(mid)", forHTTPHeaderField: "x-dod-mid")
        }
        self.urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    }
}
