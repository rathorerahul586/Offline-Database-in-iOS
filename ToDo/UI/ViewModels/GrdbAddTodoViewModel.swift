//
//  GrdbAddTodoViewModel.swift
//  ToDo
//
//  Created by Rahul Kumar on 06/09/23.
//

import Foundation

class GrdbAddTodoViewModel: AddTaskProtocal {
    
    func insertNewTask(title: String?, description: String?, todoDate: Date?) {
        do {
            try dbQueue.write { db in
                var task = GRDBTask()
                task.title = title
                task.des = description
                task.todoDate = todoDate
                task.createdAt = Date()
                task.isCompleted = false
                task.todoId = String(Date().timeIntervalSince1970)
                
                try! task.insert(db)

            }
        } catch {
            print("\(error)")
        }
    }
    
    func updateTask(taskId: String, title: String?, description: String?, todoDate: Date?) {
        do {
            try dbQueue.write { db in
                try db.execute(
                    sql: Constants.queryGrdbUpdateDataById,
                    arguments: [title, description, todoDate, Date(), taskId]
                )
            }
        } catch {
            print(error)
        }
    }
}
