import Foundation
import SQLite3

/// Simple SQLite-backed store for goals. Uses Apple's built-in SQLite3 C API —
/// no external library needed.
///
/// ⚠️ Setup note: in Xcode, add `libsqlite3.tbd` under
/// Target > Build Phases > Link Binary With Libraries, otherwise `import SQLite3` fails.
final class GoalDatabaseManager {
    static let shared = GoalDatabaseManager()

    private var db: OpaquePointer?
    private let dbFileName = "goals.sqlite"

    private init() {
        openDatabase()
        createTable()
    }

    // MARK: - Setup
    private func openDatabase() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("GoalDatabaseManager: could not find documents directory")
            return
        }
        
        let dbURL = documentsURL.appendingPathComponent(dbFileName)

        if sqlite3_open(dbURL.path, &db) != SQLITE_OK {
            print("GoalDatabaseManager: error opening database — \(errorMessage)")
        }
    }

    private func createTable() {
        let sql = """
        CREATE TABLE IF NOT EXISTS goals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT NOT NULL,
            title TEXT NOT NULL,
            goalDescription TEXT NOT NULL DEFAULT '',
            priority TEXT NOT NULL,
            status TEXT NOT NULL,
            startDate REAL NOT NULL,
            targetDate REAL NOT NULL,
            createdAt REAL NOT NULL
        );
        """

        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("GoalDatabaseManager: error preparing create table — \(errorMessage)")
            return
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            print("GoalDatabaseManager: error creating table — \(errorMessage)")
        }
    }

    private var errorMessage: String {
        String(cString: sqlite3_errmsg(db))
    }

    // MARK: - Create
    @discardableResult
    func insertGoal(_ goal: Goal) -> Int64? {
        let sql = """
        INSERT INTO goals (category, title, goalDescription, priority, status, startDate, targetDate, createdAt)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?);
        """

        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("GoalDatabaseManager: error preparing insert — \(errorMessage)")
            return nil
        }

        bindText(statement, 1, goal.category.rawValue)
        bindText(statement, 2, goal.title)
        bindText(statement, 3, goal.description)
        bindText(statement, 4, goal.priority.rawValue)
        bindText(statement, 5, goal.status.rawValue)
        sqlite3_bind_double(statement, 6, goal.startDate.timeIntervalSince1970)
        sqlite3_bind_double(statement, 7, goal.targetDate.timeIntervalSince1970)
        sqlite3_bind_double(statement, 8, goal.createdAt.timeIntervalSince1970)

        guard sqlite3_step(statement) == SQLITE_DONE else {
            print("GoalDatabaseManager: error inserting goal — \(errorMessage)")
            return nil
        }

        return sqlite3_last_insert_rowid(db)
    }

    // MARK: - Read
    func fetchAllGoals() -> [Goal] {
        let sql = """
        SELECT id, category, title, goalDescription, priority, status, startDate, targetDate, createdAt
        FROM goals ORDER BY createdAt DESC;
        """

        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("GoalDatabaseManager: error preparing fetch all — \(errorMessage)")
            return []
        }

        var goals: [Goal] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            if let goal = goal(from: statement) {
                goals.append(goal)
            }
        }
        return goals
    }

    func fetchGoal(by id: Int64) -> Goal? {
        let sql = """
        SELECT id, category, title, goalDescription, priority, status, startDate, targetDate, createdAt
        FROM goals WHERE id = ?;
        """

        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("GoalDatabaseManager: error preparing fetch by id — \(errorMessage)")
            return nil
        }
        sqlite3_bind_int64(statement, 1, id)

        guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
        return goal(from: statement)
    }

    // MARK: - Update (all editable fields)
    @discardableResult
    func updateGoal(_ goal: Goal) -> Bool {
        guard let id = goal.id else {
            print("GoalDatabaseManager: cannot update a goal with no id")
            return false
        }

        let sql = """
        UPDATE goals
        SET category = ?, title = ?, goalDescription = ?, priority = ?, status = ?, startDate = ?, targetDate = ?
        WHERE id = ?;
        """

        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("GoalDatabaseManager: error preparing update — \(errorMessage)")
            return false
        }

        bindText(statement, 1, goal.category.rawValue)
        bindText(statement, 2, goal.title)
        bindText(statement, 3, goal.description)
        bindText(statement, 4, goal.priority.rawValue)
        bindText(statement, 5, goal.status.rawValue)
        sqlite3_bind_double(statement, 6, goal.startDate.timeIntervalSince1970)
        sqlite3_bind_double(statement, 7, goal.targetDate.timeIntervalSince1970)
        sqlite3_bind_int64(statement, 8, id)

        guard sqlite3_step(statement) == SQLITE_DONE else {
            print("GoalDatabaseManager: error updating goal — \(errorMessage)")
            return false
        }
        return true
    }

    // MARK: - Update priority only (for a quick priority-change action)
    @discardableResult
    func updatePriority(id: Int64, priority: GoalPriority) -> Bool {
        let sql = "UPDATE goals SET priority = ? WHERE id = ?;"

        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("GoalDatabaseManager: error preparing priority update — \(errorMessage)")
            return false
        }

        bindText(statement, 1, priority.rawValue)
        sqlite3_bind_int64(statement, 2, id)

        return sqlite3_step(statement) == SQLITE_DONE
    }

    // MARK: - Update status only (In Progress <-> Done)
    @discardableResult
    func updateStatus(id: Int64, status: GoalStatus) -> Bool {
        let sql = "UPDATE goals SET status = ? WHERE id = ?;"

        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("GoalDatabaseManager: error preparing status update — \(errorMessage)")
            return false
        }

        bindText(statement, 1, status.rawValue)
        sqlite3_bind_int64(statement, 2, id)

        return sqlite3_step(statement) == SQLITE_DONE
    }

    // MARK: - Delete
    @discardableResult
    func deleteGoal(id: Int64) -> Bool {
        let sql = "DELETE FROM goals WHERE id = ?;"

        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("GoalDatabaseManager: error preparing delete — \(errorMessage)")
            return false
        }
        sqlite3_bind_int64(statement, 1, id)

        return sqlite3_step(statement) == SQLITE_DONE
    }

    // MARK: - Helpers
    private func bindText(_ statement: OpaquePointer?, _ index: Int32, _ value: String) {
        sqlite3_bind_text(statement, index, (value as NSString).utf8String, -1, nil)
    }

    private func columnText(_ statement: OpaquePointer, _ index: Int32) -> String {
        guard let cString = sqlite3_column_text(statement, index) else { return "" }
        return String(cString: cString)
    }

    private func goal(from statement: OpaquePointer?) -> Goal? {
        guard let statement else { return nil }

        let id = sqlite3_column_int64(statement, 0)
        let categoryRaw = columnText(statement, 1)
        let title = columnText(statement, 2)
        let description = columnText(statement, 3)
        let priorityRaw = columnText(statement, 4)
        let statusRaw = columnText(statement, 5)
        let startDate = Date(timeIntervalSince1970: sqlite3_column_double(statement, 6))
        let targetDate = Date(timeIntervalSince1970: sqlite3_column_double(statement, 7))
        let createdAt = Date(timeIntervalSince1970: sqlite3_column_double(statement, 8))

        guard let category = GoalCategory(rawValue: categoryRaw),
              let priority = GoalPriority(rawValue: priorityRaw),
              let status = GoalStatus(rawValue: statusRaw) else {
            print("GoalDatabaseManager: skipped a row with unrecognized enum value")
            return nil
        }

        return Goal(
            id: id,
            category: category,
            title: title,
            description: description,
            priority: priority,
            status: status,
            startDate: startDate,
            targetDate: targetDate,
            createdAt: createdAt
        )
    }
}
