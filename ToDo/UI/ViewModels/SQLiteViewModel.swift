//
//  SQLIteViewModel.swift
//  ToDo
//
//  Created by Rahul Kumar on 04/09/23.
//

import Foundation
import RxRelay

class SQLiteViewModel: TodoListViewModelProtocal {
    var selectedTabType: TodoTypeEnums = .incomplete
    
    var todoListPublishObject = BehaviorRelay<[TodoTaskProtocal]>(value: [])
    
    var db = DBManager() 
    
    func retriveTodosData() {
        todoListPublishObject.accept(db.read(appliedFilter: selectedTabType))
    }
    
    func deleteTodo(todoId: String, completion: (() -> Void)) {
        if db.deleteByID(taskId: todoId) {
            completion()
        }
    }
    
    func markAsCompleted(todoId: String, isCompleted: Bool) {
        db.markCompletedById(taskId: todoId, isCompleted: !isCompleted)
        retriveTodosData()
    }
    
    
}
