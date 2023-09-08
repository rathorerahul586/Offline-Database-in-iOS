//
//  GRDBDatebase.swift
//  ToDo
//
//  Created by Rahul Kumar on 06/09/23.
//

import Foundation
import GRDB

var dbQueue: DatabaseQueue!

struct GRDBDatebase {
    static func setup() throws {
        let databaseURL = try FileManager.default
            .url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(Constants.dbPath)
        
        dbQueue = try DatabaseQueue(path: databaseURL.path)
        try migrator.migrate(dbQueue)
    }
    
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1") { db in
            try db.create(table: Constants.grdbDBName) { t in
                t.column(Constants.keyTodoId)
                t.column(Constants.keyTitle)
                t.column(Constants.keyDescription)
                t.column(Constants.keyTodoDate)
                t.column(Constants.keyCreatedAt)
                t.column(Constants.keyUpdatedAt)
                t.column(Constants.keyIsCompleted)
            }
        }
        
        return migrator
    }


}
