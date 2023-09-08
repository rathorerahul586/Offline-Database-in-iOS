//
//  TodoViewModel.swift
//  ToDo
//
//  Created by Rahul Kumar on 25/08/23.
//

import Foundation
import UIKit
import CoreData
import RxSwift
import RxRelay

class CoreDataDBViewModel: TodoListViewModelProtocal {
    var todoListPublishObject = BehaviorRelay<[TodoTaskProtocal]>(value: [])
    var selectedTabType: TodoTypeEnums = .incomplete
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var managedContext: NSManagedObjectContext?
    
    func retriveTodosData(){
        print("Retriving data....")
        let fetchRequest = Task.fetchRequest()
        
        do {
            fetchRequest.predicate = getFilterPredicate()
            let todos = try getContext().fetch(fetchRequest)
            
            let coreTasks: [CoreDataTask] = todos.map { task in
                let coreTask = CoreDataTask()
                coreTask.todoId = task.todoId
                coreTask.title = task.title
                coreTask.des = task.des
                coreTask.todoDate = task.todoDate
                coreTask.createdAt = task.createdAt
                coreTask.updatedAt = task.updatedAt
                coreTask.isCompleted = task.isCompleted
                return coreTask
            }
            
            todoListPublishObject.accept(coreTasks)
            
        } catch let error as NSError {
            print("Unable to save Todo due to \(error)")
        }
    }
    
    func deleteTodo(todoId: String, completion: (() -> Void)){
        
        let fetchRequest = NSFetchRequest<Task>(entityName: Constants.dbName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.keyTodoId) = %@", todoId)
        
        do {
            if let todoToDelete = try getContext().fetch(fetchRequest).first {
                getContext().delete(todoToDelete)
            }
            try getContext().save()
            completion()
        } catch {
            print(error)
        }
    }
    
    func markAsCompleted(todoId: String, isCompleted: Bool){
        let fetchRequest = NSFetchRequest<Task>(entityName: Constants.dbName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.keyTodoId) = %@", todoId)
        
        do {
            var task = try getContext().fetch(fetchRequest).first
            task?.isCompleted = !isCompleted
            try getContext().save()
            self.retriveTodosData()
            
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
