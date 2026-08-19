//
//  MyGoalViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//

import Foundation
import Combine

class MyGoalViewModel: ObservableObject {
    private let database = GoalDatabaseManager.shared
    
    @Published var goals: [Goal] = []
    @Published var totalCount: Int?
    @Published var doneCount: Int?
    @Published var inProgressCount: Int?
    
    func getGoals() {
        var allGoals = database.fetchAllGoals()
        let calendar = Calendar.current
        self.totalCount = allGoals.count
        self.inProgressCount = allGoals.filter { $0.status == .inProgress }.count
        self.doneCount = allGoals.filter { $0.status == .done }.count
        
        for index in allGoals.indices {
            if calendar.isDateInTomorrow(allGoals[index].targetDate), allGoals[index].status != .done {
                allGoals[index].status = .done
                if let id = allGoals[index].id {
                    database.updateStatus(id: id, status: .done)
                }
            }
        }
 
        // Done goals don't show up in this list
        self.goals = allGoals.filter { $0.status != .done }
    }
}
