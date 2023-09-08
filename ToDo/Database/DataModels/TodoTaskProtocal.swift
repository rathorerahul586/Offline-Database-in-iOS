//
//  TodoTaskProtocal.swift
//  ToDo
//
//  Created by Rahul Kumar on 01/09/23.
//

import Foundation
protocol TodoTaskProtocal {
    var todoId: String? { get set }
    var title: String? { get set }
    var createdAt: Date? { get set }
    var des: String? { get set }
    var isCompleted: Bool { get set }
    var updatedAt: Date? { get set }
    var todoDate: Date? { get set }
}
