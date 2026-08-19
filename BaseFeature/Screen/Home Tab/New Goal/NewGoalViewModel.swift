//
//  NewGoalViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//

import Foundation
import Combine

class NewGoalViewModel: ObservableObject {
    @Published var selectedCategory: GoalCategory = .work
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var priority: GoalPriority = .medium
    @Published var startDate: Date = Date()
    @Published var targetDate: Date = Date()
    @Published var selectedPrioritySegment: Int = 1
    @Published var showValidationError = false
    @Published var validationMessage = ""

    private let database = GoalDatabaseManager.shared

    @discardableResult
    func createGoal() -> Int64? {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            validationMessage = "ENTER_GOAL_TITLE".localized()
            showValidationError = true
            return nil
        }

        guard targetDate >= startDate else {
            validationMessage = "TARGET_DATE_ERROR".localized()
            showValidationError = true
            return nil
        }

        let goal = Goal(
            id: nil,
            category: selectedCategory,
            title: trimmedTitle,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            priority: priority,
            status: .inProgress,
            startDate: startDate,
            targetDate: targetDate,
            createdAt: Date()
        )

        guard let newId = database.insertGoal(goal) else {
            validationMessage = "GOAL_NOT_SAVED".localized()
            showValidationError = true
            return nil
        }

        return newId
    }

    func resetForm() {
        selectedCategory = .work
        title = ""
        description = ""
        priority = .medium
        startDate = Date()
        targetDate = Date()
    }
}
