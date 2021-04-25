//
//  ViewModelType.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/19.
//

import Foundation

protocol ViewModelType  {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
