//
//  CoreDataManager.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/05/19.
//

import Foundation
import CoreData

public class CoreDataManager {
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
            request.predicate = NSPredicate(format: "dueDate == %@", dueDate)
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
            request.predicate = NSPredicate(format: "id == %@", bigID)
            result = try context.fetch(request)
            
            return result.first
        }
        catch {
            return result.first
        }
    }
    
    private func fetchTodo(by createdAt: Date) -> ToDoLocal? {
        var result: [ToDoLocal] = []
        do {
            let request: NSFetchRequest = ToDoLocal.fetchRequest()
            
            request.predicate = NSPredicate(format: "createdAt == %@", createdAt.toCreatedAtString)
            result = try context.fetch(request)
            
            return result.first
        }
        catch {
            return result.first
        }
    }
    
    internal func fetchTodo(by toDo: Todo) -> ToDoLocal? {
        return ToDoLocal()
    }
    
    internal func fetchAllTodo() -> [ToDoLocal] {
        var result: [ToDoLocal] = []
        do {
            let request: NSFetchRequest = ToDoLocal.fetchRequest()
            result = try context.fetch(request)
            return result
        }
        catch {
            return result
        }
    }
    
    internal func fetchNonSyncRemoteDB() -> [ToDoLocal] {
        var result: [ToDoLocal] = []
        do {
            let request: NSFetchRequest = ToDoLocal.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", -1)
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
            updatingObject.setValue(state.rawValue, forKey: "status")
            try context.save()

            return true
        }
        catch {
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
            try context.save()

            return true
        }
        catch {
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
            
            do {
                try context.save()
                return true
            }
            catch {
                return false
            }
        }
        
        return false
    }
    
    internal func delete(toDo: Todo) -> Bool {
        do {
            guard let deletingObject = fetchTodo(by: toDo) else {
                return false
            }
            context.delete(deletingObject)
            
            try context.save()
            return true
            
        }
        catch {
            return false
        }
    }
}
