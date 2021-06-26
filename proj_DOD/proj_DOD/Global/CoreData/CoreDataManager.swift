//
//  CoreDataManager.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/05/19.
//

import Foundation
import CoreData

internal class CoreDataManager {
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocalData")
        container.loadPersistentStores{ (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    internal func fetchTodosOfDueDate(by dueDate: String) -> [ToDoLocal] {
        var result: [ToDoLocal] = []
        do {
            let request: NSFetchRequest = ToDoLocal.fetchRequest()
            request.predicate = NSPredicate(format: "dueDate == %@ AND hasDeleted == %@",
                                            dueDate, false.toNSNumber)
            result = try context.fetch(request)
            return result
        }
        catch {
            return result
        }
    }
    
    private func fetchTodo(by id: Int) -> ToDoLocal? {
        var result: [ToDoLocal] = []
        do {
            let request: NSFetchRequest = ToDoLocal.fetchRequest()
            let bigID = Int64(id)
            request.predicate = NSPredicate(format: "id == %@ AND hasDeleted == %@",
                                            bigID, false.toNSNumber)
            result = try context.fetch(request)
            
            return result.first
        }
        catch {
            return result.first
        }
    }
    
    private func fetchTodo(by createdAt: String) -> ToDoLocal? {
        var result: [ToDoLocal] = []
        do {
            let request: NSFetchRequest = ToDoLocal.fetchRequest()
            
            request.predicate = NSPredicate(format: "createdAt == %@ AND hasDeleted == %@",
                                            createdAt, false.toNSNumber)
            result = try context.fetch(request)
            
            return result.first
        }
        catch {
            return result.first
        }
    }
    
    internal func fetchTodo(by toDo: Todo) -> ToDoLocal? {
        let result = toDo.id != -1 ? fetchTodo(by: toDo.id) : fetchTodo(by: "")
//        let result = toDo.id != -1 ? fetchTodo(by: toDo.id) : fetchTodo(by: toDo.createdAt)
        return result
    }
    
    internal func fetchAllTodo() -> [ToDoLocal] {
        var result: [ToDoLocal] = []
        do {
            let request: NSFetchRequest = ToDoLocal.fetchRequest()
            request.predicate = NSPredicate(format: "hasDeleted == %@", false.toNSNumber)
            result = try context.fetch(request)
            return result
        }
        catch {
            return result
        }
    }
    
    internal func fetchNonSyncRemoteDB(hasDeleted: Bool) -> [ToDoLocal] {
        var result: [ToDoLocal] = []
        do {
            let request: NSFetchRequest = ToDoLocal.fetchRequest()
            request.predicate = NSPredicate(format: "hasRemoteUpdated == %@ AND hasDeleted == %@",
                                            false.toNSNumber,
                                            hasDeleted.toNSNumber)
            result = try context.fetch(request)
            return result
        }
        catch {
            return result
        }
    }
    
    internal func updateTodoStatus(at toDo: Todo, to state: Status) -> Bool {
        do {
            guard let updatingObject = fetchTodo(by: toDo) else {
                return false
            }
            updatingObject.setValue(state.statusMessage, forKey: "status")
            updatingObject.setValue(false.toNSNumber, forKey: "hasRemoteUpdated")
            try context.save()
            
            return true
        }
        catch {
            context.rollback()
            return false
        }
    }
    
    internal func updateTodoInfo(at oldTodo: Todo, to newTodo: Todo) -> Bool {
        do {
            guard let updatingObject = fetchTodo(by: oldTodo) else {
                return false
            }
            updatingObject.setValue(newTodo.title, forKey: "title")
            updatingObject.setValue(newTodo.dueDate, forKey: "dueDate")
            updatingObject.setValue(newTodo.status, forKey: "status")
            updatingObject.setValue(false.toNSNumber, forKey: "hasRemoteUpdated")
            try context.save()

            return true
        }
        catch {
            context.rollback()
            return false
        }
    }
    
    internal func createNewTodo(toDo: Todo) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "ToDoLocal", in: context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(toDo.title, forKey: "title")
            managedObject.setValue(toDo.status, forKey: "status")
            managedObject.setValue(toDo.dueDate, forKey: "dueDate")
            managedObject.setValue(false.toNSNumber, forKey: "hasRemoteUpdated")
            do {
                try context.save()
                return true
            }
            catch {
                context.rollback()
                return false
            }
        }
        
        return false
    }
    
    @discardableResult
    internal func updateLocalData(by toDos: [Todo]) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "ToDoLocal", in: context)
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            toDos.forEach{ toDo in
                managedObject.setValue(toDo.id, forKey: "id")
                managedObject.setValue(toDo.memberID, forKey: "memberID")
                managedObject.setValue(toDo.title, forKey: "title")
                managedObject.setValue(toDo.status, forKey: "status")
                managedObject.setValue(toDo.dueDate, forKey: "dueDate")
                managedObject.setValue(true.toNSNumber, forKey: "hasRemoteUpdated")
            }
            
            do {
                try context.save()
                return true
            }
            catch {
                context.rollback()
                return false
            }
        }
        
        return false
    }
    
    internal func setDeleteState(toDo: Todo) -> Bool {
        do {
            guard let deletingObject = fetchTodo(by: toDo) else {
                return false
            }
            deletingObject.setValue(true, forKey: "hadDeleted")
            deletingObject.setValue(false, forKey: "hasRemoteUpdated")
            
            try context.save()
            return true
            
        }
        catch {
            context.rollback()
            return false
        }
    }
    
    @discardableResult
    internal func setNewTodoRemoteUpdate(toDo: Todo, id: Int, memberId: Int) -> Bool {
        do {
            guard let remoteUpdatedObject = fetchTodo(by: toDo) else {
                return false
            }
            remoteUpdatedObject.setValue(id, forKey: "id")
            remoteUpdatedObject.setValue(memberId, forKey: "memberId")
            remoteUpdatedObject.setValue(true, forKey: "hasRemoteUpdated")
            try context.save()
            return true
        }
        catch {
            context.rollback()
            return false
        }
    }
    
    @discardableResult
    internal func setTodoRemoteUpdate(toDo: Todo) -> Bool {
        do {
            guard let remoteUpdatedObject = fetchTodo(by: toDo) else {
                return false
            }
            remoteUpdatedObject.setValue(true, forKey: "hasRemoteUpdated")
            try context.save()
            return true
        }
        catch {
            context.rollback()
            return false
        }
    }
    
    internal func cleanDeletedData() -> Bool {
        var result: [ToDoLocal] = []
        do {
            let request: NSFetchRequest = ToDoLocal.fetchRequest()
            request.predicate = NSPredicate(format: "hasRemoteUpdated == %@ AND hasDeleted == %@", true.toNSNumber, true.toNSNumber)
            result = try context.fetch(request)
            
            result.forEach{
                context.delete($0)
            }
            try context.save()
            
            return true
        }
        catch {
            return false
        }
    }
    
    internal func deleteAlreadyUpdatedData() -> Bool {
        var result: [ToDoLocal] = []
        do {
            let request: NSFetchRequest = ToDoLocal.fetchRequest()
            request.predicate = NSPredicate(format: "hasRemoteUpdated == %@", true.toNSNumber)
            result = try context.fetch(request)
            
            result.forEach{
                context.delete($0)
            }
            try context.save()
            
            return true
        }
        catch {
            return false
        }
    }
}
