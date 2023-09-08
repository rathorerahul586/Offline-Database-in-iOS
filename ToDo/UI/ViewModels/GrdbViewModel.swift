//
//  GrdbViewModel.swift
//  ToDo
//
//  Created by Rahul Kumar on 06/09/23.
//

import Foundation
import RxRelay
import GRDB

class GrdbViewModel: TodoListViewModelProtocal {
    var selectedTabType: TodoTypeEnums = .incomplete
    
    var todoListPublishObject = BehaviorRelay<[TodoTaskProtocal]>(value: [])
    
    init() {
        do {
            try GRDBDatebase.setup()
        } catch {
            print("Init Error - \(error)")
        }
    }
    
    func retriveTodosData() {
        do {
            try dbQueue.read { db in
                let drafts: [TodoTaskProtocal]
                switch selectedTabType {
                case .overdue:
                    try drafts = GRDBTask.overdue().fetchAll(db)
                case .incomplete:
                    try drafts = GRDBTask.incomplete().fetchAll(db)
                case .completed:
                    try drafts = GRDBTask.completed().fetchAll(db)
                }
                    
                todoListPublishObject.accept(drafts)
            }
        } catch {
            print("\(error)")
        }
    }
    
    func deleteTodo(todoId: String, completion: (() -> Void)) {
        do {
            try dbQueue.write { db in
                try db.execute(
                    sql: Constants.queryGrdbDeleteById,
                    arguments: [todoId]
                )
            }
        } catch {
            print(error)
        }
        retriveTodosData()
    }
    
    func markAsCompleted(todoId: String, isCompleted: Bool) {
        do {
            try dbQueue.write { db in
                try db.execute(
                    sql: Constants.queryGrdbMarkCompletedById,
                    arguments: [!isCompleted, todoId]
                )
            }
        }
        catch {
            print(error)
        }
        retriveTodosData()
    }
}
