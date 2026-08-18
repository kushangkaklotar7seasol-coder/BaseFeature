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

    /// Validates the form and saves a new goal. Status is always "In Progress" at creation.
    /// Returns the new goal's database id on success, nil if validation failed.
    @discardableResult
    func createGoal() -> Int64? {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            validationMessage = "Please enter a goal title"
            showValidationError = true
            return nil
        }

        guard targetDate >= startDate else {
            validationMessage = "Target date must be on or after the start date"
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
            validationMessage = "Something went wrong saving this goal. Please try again."
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
