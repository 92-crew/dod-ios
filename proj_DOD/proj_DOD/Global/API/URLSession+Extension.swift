//
//  URLSession+Extension.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/14.
//

import Foundation

extension URLSession {
    func load(
        _ resource: Resource,
        completion: @escaping (NetworkResult<Data?>) -> Void
    ) {
        dataTask(with: resource.urlRequest) { data, response, _ in
            if let response = response as? HTTPURLResponse{
                switch response.statusCode {
                case 200:
                    completion(.success(data))
                default:
                    completion(.requestErr(data))
                }
            }
            else {
                completion(.networkFail)
            }
        }.resume()
    }
}
