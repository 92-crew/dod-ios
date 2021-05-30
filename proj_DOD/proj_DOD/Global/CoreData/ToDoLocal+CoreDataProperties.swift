//
//  ToDoLocal+CoreDataProperties.swift
//  
//
//  Created by 이주혁 on 2021/05/30.
//
//

import Foundation
import CoreData


extension ToDoLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoLocal> {
        return NSFetchRequest<ToDoLocal>(entityName: "ToDoLocal")
    }

    @NSManaged public var dueDate: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var id: Int64
    @NSManaged public var memberID: Int64

}
