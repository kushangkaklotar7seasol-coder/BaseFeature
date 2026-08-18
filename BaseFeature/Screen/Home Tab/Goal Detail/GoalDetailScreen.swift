//
//  GoalDetailScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//

import SwiftUI

struct GoalDetailScreen: View {
    @StateObject var viewModel: GoalDetailViewModel
    @ObservedObject var goalViewModel = GoalsListViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "Goals Details")
                    .padding(.horizontal, 16)
                
                if let goal = viewModel.goal {
                    GoalCardView(goal: goal)
                }
                
                VStack {
                    HStack {
                        Text("Status")
                        
                        Spacer()
                        
                        Menu("\(viewModel.goal?.priority.rawValue ?? "Nil")") {
                            ForEach(GoalPriority.allCases, id: \.self) { level in
                                Button(level.title) {
                                    if let goal = viewModel.goal {
                                        goalViewModel.changePriority(for: goal, to: level)
                                        viewModel.goal?.priority = level
                                    }
                                }
//                                .background(level.priority.badgeBackgroundColor)
                            }
                        }
                        .padding(5)
                        .background(viewModel.goal?.priority == .high ? .red : viewModel.goal?.priority == .medium ? .yellow : .green)
                        .cornerRadius(5)
                    }
                }
                .padding()
                .background(.whiteColour.opacity(0.08))
                .cornerRadius(12)
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .defaultPage()
    }
}

#Preview {
    GoalDetailScreen(viewModel: GoalDetailViewModel())
}
