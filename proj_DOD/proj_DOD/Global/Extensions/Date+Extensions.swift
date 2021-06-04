//
//  Date+Extensions.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/05/02.
//

import Foundation
extension Date {
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }

    public var day: Int {
         return Calendar.current.component(.day, from: self)
    }
    
    public var toCreatedAtString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        return dateFormatter.string(from: self)
    }
    
    public func toString() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
}
