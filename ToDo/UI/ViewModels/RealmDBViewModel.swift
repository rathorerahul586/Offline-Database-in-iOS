//
//  RealmDBViewModel.swift
//  ToDo
//
//  Created by Rahul Kumar on 31/08/23.
//

import Foundation
import RxSwift
import RxRelay
import RealmSwift

class RealmDBViewModel: TodoListViewModelProtocal {
    var todoListPublishObject = BehaviorRelay<[TodoTaskProtocal]>(value: [])

    var selectedTabType: TodoTypeEnums = .incomplete
    
    private var realmDB: Realm?
    
    func initDb() {
        do {
            realmDB = try Realm()
        } catch {
            print(error)
        }
    }
    
    func retriveTodosData(){
        if realmDB == nil {
            initDb()
        }
        
        if let tasks = realmDB?.objects(RealmTask.self).filter(getFilterPredicate()) {
            var taskList: [RealmTask] = []
            for task in tasks {
                taskList.append(task)
            }
            todoListPublishObject.accept(taskList)
        }
    }
    
    func deleteTodo(todoId: String, completion: (() -> Void)) {
        do {
            try self.realmDB?.write {
                if let task = realmDB?.object(ofType: RealmTask.self, forPrimaryKey: todoId) {
                    self.realmDB?.delete(task)
                    completion()
                }
            }
        } catch {
            print(error)
        }
        
    }
    
    func markAsCompleted(todoId: String, isCompleted: Bool) {
        do {
            try self.realmDB?.write {
                if let task = realmDB?.object(ofType: RealmTask.self, forPrimaryKey: todoId) {
                    task.isCompleted = !isCompleted
                }
            }
            self.retriveTodosData()
        } catch {
            print(error)
        }
    }
    
}
