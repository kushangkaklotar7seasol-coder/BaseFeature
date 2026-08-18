//
//  GoalDetailViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//

import Foundation
import Combine

class GoalDetailViewModel: ObservableObject {
    @Published var goal: Goal?
    
    init(goal: Goal? = nil) {
        self.goal = goal
    }
}
