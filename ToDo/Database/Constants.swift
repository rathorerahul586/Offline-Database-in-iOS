//
//  Constants.swift
//  ToDo
//
//  Created by Rahul Kumar on 29/08/23.
//

import Foundation

class Constants {
    static let dbName = "Task"
    static let keyTodoId = "todoId"
    static let keyCreatedAt = "createdAt"
    static let keyDescription = "des"
    static let keyIsCompleted = "isCompleted"
    static let keyTitle = "title"
    static let keyUpdatedAt = "updatedAt"
    static let keyTodoDate = "todoDate"
    
    static let dateFormatter = "yyyy-MM-dd HH:mm:ss"
    static let grdbDBName = "grdbTask"
    
    // SQLite Queries
    static let dbPath = "todoList.sqlite"
    
    static let queryCreateTable = """
    CREATE TABLE IF NOT EXISTS \(dbName) (
        \(keyTodoId) TEXT PRIMARY KEY,
        \(keyTitle) TEXT,
        \(keyDescription) TEXT,
        \(keyTodoDate) TEXT,
        \(keyCreatedAt) TEXT,
        \(keyUpdatedAt) TEXT,
        \(keyIsCompleted) TEXT
    );
    """
    
    static let queryInsertData = """
    INSERT INTO \(dbName) (
        \(keyTodoId),
        \(keyTitle),
        \(keyDescription),
        \(keyTodoDate),
        \(keyCreatedAt),
        \(keyUpdatedAt),
        \(keyIsCompleted)
    ) VALUES (?, ?, ?, ?, ?, ?, ?);"
    """
    
    static let queryFilterOverdue = """
    SELECT * FROM \(dbName)
    WHERE \(keyTodoDate) < datetime('now', 'localtime')
    AND \(keyIsCompleted) = 0;
    """
    
    static let queryFilterIncomplete = """
    SELECT * FROM \(dbName)
    WHERE \(keyTodoDate) > datetime('now', 'localtime')
    AND \(keyIsCompleted) = 0;
    """
    
    static let queryFilterCompleted = """
    SELECT * FROM \(dbName)
    WHERE \(keyIsCompleted) = 1;
    """
    
    static let queryDeleteById = """
    DELETE FROM \(dbName) WHERE \(keyTodoId) = ?;
    """
    
    static let queryUpdateDataById = """
    UPDATE \(dbName) SET \(keyTitle) = ?, \(keyDescription) = ?,
    \(keyTodoDate) = ?, \(keyUpdatedAt) = ? WHERE \(keyTodoId) = ?
    """
    
    static let queryMarkCompletedById = """
    UPDATE \(dbName) SET \(keyIsCompleted) = ? WHERE \(keyTodoId) = ?
    """
    
    // GRDB Queries
    static let queryGrdbDeleteById = """
    DELETE FROM \(grdbDBName) WHERE \(keyTodoId) = ?;
    """
    
    static let queryGrdbUpdateDataById = """
    UPDATE \(grdbDBName) SET \(keyTitle) = ?, \(keyDescription) = ?,
    \(keyTodoDate) = ?, \(keyUpdatedAt) = ? WHERE \(keyTodoId) = ?
    """
    
    static let queryGrdbMarkCompletedById = """
    UPDATE \(grdbDBName) SET \(keyIsCompleted) = ? WHERE \(keyTodoId) = ?
    """
    
}
