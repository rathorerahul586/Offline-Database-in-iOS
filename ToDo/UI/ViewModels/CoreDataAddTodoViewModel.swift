//
//  AddTodoViewModel.swift
//  ToDo
//
//  Created by Rahul Kumar on 01/09/23.
//

import Foundation
import UIKit
import CoreData

class CoreDataAddTodoViewModel: AddTaskProtocal {
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var managedContext: NSManagedObjectContext?
    
    func insertNewTask(title: String?, description: String?, todoDate: Date?) {
        guard let todoEntity = NSEntityDescription.entity(
            forEntityName: Constants.dbName, in: getContext()
        ) else {return}
        
        if let todo = NSManagedObject(entity: todoEntity, insertInto: getContext()) as? Task {
            todo.title = title
            todo.des = description
            todo.todoDate = todoDate
            todo.createdAt = Date()
            todo.isCompleted = false
            todo.todoId = String(Date().timeIntervalSince1970)
        }
        
        do {
            try getContext().save()
        } catch let error as NSError {
            print("Unable to save Todo due to \(error)")
        }
    }
    
    func updateTask(taskId: String, title: String?, description: String?, todoDate: Date?) {
        let fetchRequest = NSFetchRequest<Task>(entityName: Constants.dbName)
        
        fetchRequest.predicate = NSPredicate(format: "\(Constants.keyTodoId) = %@", taskId)
        do {
           
            var task = try getContext().fetch(fetchRequest).first
            task?.title = title
            task?.des = description
            task?.todoDate = todoDate
            task?.updatedAt = Date()
            try getContext().save()
            
        } catch {
            print(error)
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        if managedContext == nil {
            managedContext = appDelegate?.persistentContainer.viewContext
        }
        return managedContext!
    }
}
