// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Add Todo
  internal static let addTodo = L10n.tr("Localizable", "addTodo", fallback: "Add Todo")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel", fallback: "Cancel")
  /// Choose Database
  internal static let chooseDatabase = L10n.tr("Localizable", "chooseDatabase", fallback: "Choose Database")
  /// Completed
  internal static let completed = L10n.tr("Localizable", "completed", fallback: "Completed")
  /// Is this task completed?
  internal static let completedMessage = L10n.tr("Localizable", "completedMessage", fallback: "Is this task completed?")
  /// Core Data
  internal static let coreData = L10n.tr("Localizable", "coreData", fallback: "Core Data")
  /// Created At:
  internal static let createdAt = L10n.tr("Localizable", "createdAt", fallback: "Created At:")
  /// Delete
  internal static let delete = L10n.tr("Localizable", "delete", fallback: "Delete")
  /// Are you sure want to delete this task?
  internal static let deleteMessage = L10n.tr("Localizable", "delete_message", fallback: "Are you sure want to delete this task?")
  /// Add some more details...
  internal static let descriptionHint = L10n.tr("Localizable", "descriptionHint", fallback: "Add some more details...")
  /// GRDB
  internal static let grdb = L10n.tr("Localizable", "grdb", fallback: "GRDB")
  /// Incomplete
  internal static let incomplete = L10n.tr("Localizable", "incomplete", fallback: "Incomplete")
  /// Last Updated At:
  internal static let lastUpdatedAt = L10n.tr("Localizable", "lastUpdatedAt:", fallback: "Last Updated At:")
  /// Mark as Completed
  internal static let markAsCompleted = L10n.tr("Localizable", "markAsCompleted", fallback: "Mark as Completed")
  /// Mark as Incomplete
  internal static let markAsIncomplete = L10n.tr("Localizable", "markAsIncomplete", fallback: "Mark as Incomplete")
  /// No Completed
  internal static let noCompleted = L10n.tr("Localizable", "noCompleted", fallback: "No Completed")
  /// You have not marked any task as completed.
  internal static let noCompletedSubtitle = L10n.tr("Localizable", "noCompletedSubtitle", fallback: "You have not marked any task as completed.")
  /// No Incomplete
  internal static let noIncomplete = L10n.tr("Localizable", "noIncomplete", fallback: "No Incomplete")
  /// There is no incomplete task. Click on + button to add new task to do.
  internal static let noIncompleteSubtitle = L10n.tr("Localizable", "noIncompleteSubtitle", fallback: "There is no incomplete task. Click on + button to add new task to do.")
  /// No Overdue
  internal static let noOverdue = L10n.tr("Localizable", "noOverdue", fallback: "No Overdue")
  /// There is no overdue task.
  internal static let noOverdueSubTitle = L10n.tr("Localizable", "noOverdueSubTitle", fallback: "There is no overdue task.")
  /// Is this task not completed?
  internal static let notCompletedMessage = L10n.tr("Localizable", "notCompletedMessage", fallback: "Is this task not completed?")
  /// Overdue
  internal static let overdue = L10n.tr("Localizable", "overdue", fallback: "Overdue")
  /// Realm
  internal static let realm = L10n.tr("Localizable", "realm", fallback: "Realm")
  /// Save Todo
  internal static let saveTodo = L10n.tr("Localizable", "saveTodo", fallback: "Save Todo")
  /// SQLite
  internal static let sqlite = L10n.tr("Localizable", "sqlite", fallback: "SQLite")
  /// What to do?
  internal static let titleHint = L10n.tr("Localizable", "titleHint", fallback: "What to do?")
  /// Localizable.strings
  ///   ToDo
  /// 
  ///   Created by Rahul Kumar on 31/08/23.
  internal static let todo = L10n.tr("Localizable", "todo", fallback: "Todo")
  /// Yes
  internal static let yes = L10n.tr("Localizable", "yes", fallback: "Yes")
  /// Yes, Delete
  internal static let yesDelete = L10n.tr("Localizable", "yesDelete", fallback: "Yes, Delete")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
