//
//  GRDBTask.swift
//  ToDo
//
//  Created by Rahul Kumar on 06/09/23.
//

import Foundation
import GRDB

struct GRDBTask: TodoTaskProtocal, Codable, FetchableRecord, PersistableRecord  {
    var todoId: String?
    var title: String?
    var des: String?
    var todoDate: Date?
    var createdAt: Date?
    var updatedAt: Date?
    var isCompleted: Bool = false
}

extension GRDBTask {
    enum Columns {
        static let todoId = Column(CodingKeys.todoId)
        static let title = Column(CodingKeys.title)
        static let description = Column(CodingKeys.des)
        static let todoDate = Column(CodingKeys.todoDate)
        static let createdAt = Column(CodingKeys.createdAt)
        static let updatedAt = Column(CodingKeys.updatedAt)
        static let isCompleted = Column(CodingKeys.isCompleted)
    }
    
    static func completed() -> QueryInterfaceRequest<GRDBTask> {
        return GRDBTask.filter(Columns.isCompleted == true)
    }
    static func incomplete() -> QueryInterfaceRequest<GRDBTask> {
        return GRDBTask.filter(Columns.isCompleted == false && Columns.todoDate > Date())
    }
    static func overdue() -> QueryInterfaceRequest<GRDBTask> {
        return GRDBTask.filter(Columns.isCompleted == false && Columns.todoDate < Date())
    }
    static func getById(taskId: String) -> QueryInterfaceRequest<GRDBTask> {
        return GRDBTask.filter(Columns.todoId == taskId)
    }
}
