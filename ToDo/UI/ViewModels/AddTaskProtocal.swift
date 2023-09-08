//
//  AddTaskProtocal.swift
//  ToDo
//
//  Created by Rahul Kumar on 01/09/23.
//

import Foundation

protocol AddTaskProtocal: ObservableObject {
    func insertNewTask(title: String?, description: String?, todoDate: Date?)
    func updateTask(taskId: String, title: String?, description: String?, todoDate: Date?)
}
