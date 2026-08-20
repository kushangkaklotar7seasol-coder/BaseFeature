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
                DefaultDesign.Header(name: viewModel.header.localized())
                    .padding(.horizontal, 16)
                
                if !viewModel.goals.isEmpty {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 14) {
                            ForEach(viewModel.goals) { goal in
                                GoalCardView(goal: goal, viewModel: goalListViewModel, onDelete: {
                                    viewModel.getGoals()
                                })
                            }
                        }
                        .padding(.bottom, 80)
                    }
                }
                
                Spacer()
            }
            
            if viewModel.goals.isEmpty {
                VStack(spacing: 8) {
                    Image("ic_goal_red")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                    
                    Text("No goal found")
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
