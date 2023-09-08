//
//  TodoListViewModelProtocal.swift
//  ToDo
//
//  Created by Rahul Kumar on 01/09/23.
//

import Foundation
import RxRelay

protocol TodoListViewModelProtocal : ObservableObject {
    var selectedTabType: TodoTypeEnums { get set }
    var todoListPublishObject: BehaviorRelay<[TodoTaskProtocal]> { get set }
    func retriveTodosData()
    func deleteTodo(todoId: String, completion: (() -> Void))
    func markAsCompleted(todoId: String, isCompleted: Bool)
}

extension TodoListViewModelProtocal {
    func getFilterPredicate() -> NSCompoundPredicate {
        var predicateFirst = NSPredicate(value: true)
        var predicateSecond = NSPredicate(value: true)
        switch(selectedTabType) {
            
        case .overdue:
            let currentDate = Date()
            predicateFirst = NSPredicate(format: "\(Constants.keyIsCompleted) = %@", NSNumber(value: false))
            predicateSecond = NSPredicate(format: "\(Constants.keyTodoDate) < %@", currentDate as NSDate)
        case .incomplete:
            let currentDate = Date()
            predicateFirst = NSPredicate(format: "\(Constants.keyIsCompleted) = %@", NSNumber(value: false))
            predicateSecond = NSPredicate(format: "\(Constants.keyTodoDate) > %@", currentDate as NSDate)
        case .completed:
            
            predicateFirst = NSPredicate(format: "\(Constants.keyIsCompleted) = %@", NSNumber(value: true))
        }
        
        return NSCompoundPredicate(
            andPredicateWithSubpredicates: [predicateFirst, predicateSecond]
        )
    }
}
