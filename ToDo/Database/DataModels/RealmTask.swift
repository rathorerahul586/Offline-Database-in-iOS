//
//  RealmTask.swift
//  ToDo
//
//  Created by Rahul Kumar on 31/08/23.
//

import Foundation
import RealmSwift

class RealmTask: Object, TodoTaskProtocal {
    @objc dynamic var todoId: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var des: String?
    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var title: String?
    @objc dynamic var updatedAt: Date?
    @objc dynamic var todoDate: Date?
    
    override static func primaryKey() -> String? {
        return "todoId"
    }
}
