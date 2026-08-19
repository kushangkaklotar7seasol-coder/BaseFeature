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
    @Published var header: String = ""
    @Published var goals: [Goal] = []
    var type: Int?  //0=All Goal, 1=Done Goal, 2=In progress
    
    init(type: Int? = nil) {
        self.type = type
    }
    
    func getGoals() {
        let allGoals = database.fetchAllGoals()
 
        switch type {
        case 1:
            self.goals = allGoals.filter { $0.status == .done }
            self.header = "Done Goal"
        case 2:
            self.goals = allGoals.filter { $0.status == .inProgress }
            self.header = "In Progress"
        default: // nil or 0 -> All Goals
            self.goals = allGoals
            self.header = "My Goals"
        }
    }
}
