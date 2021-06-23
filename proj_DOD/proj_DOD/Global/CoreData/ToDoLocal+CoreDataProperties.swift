//
//  ToDoLocal+CoreDataProperties.swift
//  
//
//  Created by 이주혁 on 2021/06/20.
//
//

import Foundation
import CoreData


extension ToDoLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoLocal> {
        return NSFetchRequest<ToDoLocal>(entityName: "ToDoLocal")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var dueDate: String?
    @NSManaged public var hasDeleted: Bool
    @NSManaged public var hasRemoteUpdated: Bool
    @NSManaged public var id: Int64
    @NSManaged public var memberID: Int64
    @NSManaged public var status: String?
    @NSManaged public var title: String?

    internal func toTodo() -> Todo {
        return Todo(id: Int(self.id),
                    memberID: Int(self.memberID),
                    title: self.title ?? "",
                    status: self.status ?? "",
                    dueDate: self.dueDate ?? "")
    }
}
