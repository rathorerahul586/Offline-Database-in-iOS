//
//  AddTodoRealm.swift
//  ToDo
//
//  Created by Rahul Kumar on 01/09/23.
//

import Foundation
import RealmSwift

class RealmAddTodoViewModel: AddTaskProtocal {
    
    private var realmDB: Realm?
    
    func initDb() {
        do {
            realmDB = try Realm()
        } catch {
            print(error)
        }
    }
    
    func insertNewTask(title: String?, description: String?, todoDate: Date?) {
        if realmDB == nil {
            initDb()
        }
        let task = RealmTask()
        task.title = title
        task.des = description
        task.todoDate = todoDate
        task.createdAt = Date()
        task.isCompleted = false
        task.todoId = String(Date().timeIntervalSince1970)
        
        do {
            try self.realmDB?.write {
                self.realmDB?.add(task)
            }
        } catch {
            print(error)
        }
        
    }
    
    func updateTask(taskId: String, title: String?, description: String?, todoDate: Date?) {
        if realmDB == nil {
            initDb()
        }
        do {
            try self.realmDB?.write {
                if let task = realmDB?.object(ofType: RealmTask.self, forPrimaryKey: taskId) {
                    task.title = title
                    task.des = description
                    task.todoDate = todoDate
                    task.updatedAt = Date()
                }
            }
        } catch {
            print(error)
        }
    }
}
