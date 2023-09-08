//
//  DBManager.swift
//  ToDo
//
//  Created by Rahul Kumar on 04/09/23.
//

import Foundation
import SQLite3

class DBManager {

    init() {
        db = openDatabase()
        createTable()
    }

    var db:OpaquePointer?
    
    func openDatabase() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent(Constants.dbPath)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            debugPrint("can't open database")
            return nil
        }
        else {
            print("Successfully created connection to database at \(Constants.dbPath)")
            return db
        }
    }
    
    func createTable() {
        
        var createTableStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, Constants.queryCreateTable, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(title: String?, description: String?, todoDate: Date) {
        let id = String(Date().timeIntervalSince1970)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatter
        
        let insertStatementString =  Constants.queryInsertData
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (title as? NSString)?.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (description as? NSString)?.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (dateFormatter.string(from: todoDate) as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, ("" as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (dateFormatter.string(from: Date()) as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 7, 0)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func updateTaskById(taskId: String, title: String?, description: String?, todoDate: Date){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatter
        
        let updateStatementString = Constants.queryUpdateDataById
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (title as? NSString)?.utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (description as? NSString)?.utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (dateFormatter.string(from: todoDate) as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (dateFormatter.string(from: Date()) as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 5, (taskId as NSString).utf8String, -1, nil)
            
            // Execute the update statement.
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Data updated successfully.")
            } else {
                print("Error updating data.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func markCompletedById(taskId: String, isCompleted: Bool){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatter
        
        let updateStatementString = Constants.queryMarkCompletedById
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, isCompleted ? 1 : 0)
            sqlite3_bind_text(updateStatement, 2, (taskId as NSString).utf8String, -1, nil)
            
            // Execute the update statement.
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Data updated successfully.")
            } else {
                print("Error updating data.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func read(appliedFilter: TodoTypeEnums) -> [SQLiteTask] {
        let queryStatementString: String
        switch appliedFilter {
        case .overdue: queryStatementString = Constants.queryFilterOverdue
        case .incomplete: queryStatementString = Constants.queryFilterIncomplete
        case .completed: queryStatementString = Constants.queryFilterCompleted
        }
        
        var queryStatement: OpaquePointer? = nil
        var emps : [SQLiteTask] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatter

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let des = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let todoDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let createdAt = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let updatedAt = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let isCompleted = sqlite3_column_int(queryStatement, 6) == 0 ? false : true
                emps.append(
                    SQLiteTask(
                        todoId: id,
                        title: title,
                        des: des,
                        todoDate: dateFormatter.date(from: todoDate),
                        createdAt: dateFormatter.date(from: createdAt),
                        updatedAt: dateFormatter.date(from: updatedAt),
                        isCompleted: isCompleted
                    )
                )
                print("Query Result:")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return emps
    }
    
    func deleteByID(taskId: String) -> Bool {
        let deleteStatementStirng = Constants.queryDeleteById
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (taskId as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                return true
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        return false
    }
    
}
