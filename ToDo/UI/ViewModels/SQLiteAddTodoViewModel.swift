//
//  SQLiteAddTodoViewModel.swift
//  ToDo
//
//  Created by Rahul Kumar on 04/09/23.
//

import Foundation

class SQLiteAddTodoViewModel: AddTaskProtocal {
    
    var db = DBManager()
    
    func insertNewTask(title: String?, description: String?, todoDate: Date?) {
        if let date = todoDate {
            db.insert(title: title, description: description, todoDate: date)
        }
    }
    
    func updateTask(taskId: String, title: String?, description: String?, todoDate: Date?) {
        if let date = todoDate {
            db.updateTaskById(taskId: taskId, title: title, description: description, todoDate: date)
        }
    }
}
