//
//  GoalListViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//

import Foundation
import Combine

class GoalListViewModel: ObservableObject {
    private let database = GoalDatabaseManager.shared
    
    @Published var goals: [Goal] = []
    
    func getGoals() {
        self.goals = database.fetchAllGoals()
    }
}
