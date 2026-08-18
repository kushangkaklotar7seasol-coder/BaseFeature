import Foundation
import Combine

/// Use this on your goals-list screen. Every mutating action re-loads the list
/// afterward so the UI always reflects what's actually in the database.
class GoalsListViewModel: ObservableObject {
    @Published var goals: [Goal] = []

    private let database = GoalDatabaseManager.shared

    func loadGoals() {
        goals = database.fetchAllGoals()
    }

    func updateGoal(_ goal: Goal) {
        guard database.updateGoal(goal) else { return }
        loadGoals()
    }

    func deleteGoal(_ goal: Goal) {
        guard let id = goal.id else { return }
        guard database.deleteGoal(id: id) else { return }
        loadGoals()
    }

    func changePriority(for goal: Goal, to priority: GoalPriority) {
        guard let id = goal.id else { return }
        guard database.updatePriority(id: id, priority: priority) else { return }
        loadGoals()
    }

    /// Flips a goal between In Progress and Done
    func toggleStatus(for goal: Goal) {
        guard let id = goal.id else { return }
        let newStatus: GoalStatus = goal.status == .done ? .inProgress : .done
        guard database.updateStatus(id: id, status: newStatus) else { return }
        loadGoals()
    }
}
