//
//  SQLiteTask.swift
//  ToDo
//
//  Created by Rahul Kumar on 04/09/23.
//

import Foundation

class SQLiteTask: TodoTaskProtocal {
    
    var todoId: String?
    var title: String?
    var des: String?
    var todoDate: Date?
    var createdAt: Date?
    var updatedAt: Date?
    var isCompleted: Bool = false
    
    init(todoId: String? = nil, title: String? = nil, des: String? = nil, todoDate: Date? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, isCompleted: Bool) {
        self.todoId = todoId
        self.title = title
        self.des = des
        self.todoDate = todoDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isCompleted = isCompleted
    }
}
