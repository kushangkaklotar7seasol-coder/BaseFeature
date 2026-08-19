//
//  GoalListScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//

import SwiftUI

struct GoalListScreen: View {
    @StateObject var viewModel: GoalListViewModel
    @StateObject var goalListViewModel = GoalsListViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: viewModel.header)
                    .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(viewModel.goals) { goal in
                            GoalCardView(goal: goal)
                        }
                    }
                    .padding(.bottom, 80)
                }
            }
        }
        .defaultPage()
        .onAppear() {
            viewModel.getGoals()
        }
    }
}

#Preview {
    GoalListScreen(viewModel: GoalListViewModel())
}
