//
//  URLSession+Extension.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/14.
//

import Foundation

extension URLSession {
    func load<T>(
        _ resource: Resource<T>,
        completion: @escaping (T?, Bool) -> Void
    ) {
        dataTask(with: resource.urlRequest) { data, response, _ in
            dump(response)
            if let response = response as? HTTPURLResponse,
               (200..<300).contains(response.statusCode) {
                completion(data.flatMap(resource.parse), true)
            }
            else {
                completion(nil, false)
            }
//            if let response = response as? HTTPURLResponse{
//                switch response.statusCode {
//                case 200..<300:
//                    if let parseData = data.flatMap(resource.parse) {
//                        completion(.success(parseData))
//                    }
//                default:
//                    completion(.pathErr)
//                }
//            }
//            else {
//                completion(.networkFail)
//            }
        }.resume()
    }
}
