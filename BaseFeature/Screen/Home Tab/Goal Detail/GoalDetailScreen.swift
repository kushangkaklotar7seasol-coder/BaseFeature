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
                DefaultDesign.Header(name: "GOAL_DETAILS", showBackbutton: true, secondButton: "DELETE", secondbuttonForegroundColour: .redColour, onSecondButtonClick: {
                    AlertManager.shared.show(
                        title: "DELETE_GOAL".localized(),
                        message: "DELETE_GOAL_INFO".localized(),
                        buttons: [
                            AlertButtonModel(title: "CANCEL".localized(), role: .cancel),
                            AlertButtonModel(title: "DELETE".localized(), role: .destructive) {
                                if let goal = viewModel.goal {
                                    goalViewModel.deleteGoal(goal)
                                    Router.shared.pop()
                                }
                            }
                        ]
                    )
                })
                .padding(.horizontal, 16)
                
                if let goal = viewModel.goal {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top, spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(goal.category.color)
                                    .frame(width: 52, height: 52)
                                
                                Image(goal.category.icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(goal.title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                HStack(spacing: 6) {
                                    Image(systemName: "calendar")
                                        .font(.caption)
                                    Text(Utility.formattedDueText(for: goal.targetDate))
                                        .font(.subheadline)
                                }
                                .foregroundColor(.gray)
                                
                                Text(goal.priority.title)
                                    .font(.caption.bold())
                                    .foregroundColor(goal.priority.badgeTextColor)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 6)
                                    .background(goal.priority.badgeBackgroundColor)
                                    .cornerRadius(20)
                            }
                            
                            Spacer()
                        }
                        .padding(14)
                    }
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                }
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        if let myGoal = viewModel.goal {
                            HStack {
                                Text("STATUS".localized())
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Spacer()
                                
                                Menu {
                                    ForEach(GoalStatus.allCases, id: \.self) { level in
                                        Button(level.title) {
                                            print(level.title)
                                            goalViewModel.toggleStatus(for: myGoal)
                                            viewModel.goal?.status = level
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(viewModel.goal?.status.title ?? "")
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                    }
                                }
                                .padding(10)
//                                .background(.whiteColour.opacity(0.5))
                                .foregroundColor(viewModel.goal?.status == .inProgress ? .softBlueColour : .cyan)
                                .background(viewModel.goal?.status == .inProgress ? .softBlueColour.opacity(0.18) : .cyan.opacity(0.18))
                                .cornerRadius(8)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
                        if let statedDate = viewModel.goal?.startDate {
                            HStack {
                                Text("START_DATE".localized())
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Spacer()
                                
                                Text(Utility.formattedDueText(for: statedDate))
                                    .font(.subheadline)
                                    .foregroundColor(.grayColour)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
                        if let targetDate = viewModel.goal?.targetDate {
                            HStack {
                                Text("TARGET_DATE".localized())
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Spacer()
                                
                                Text(Utility.formattedDueText(for: targetDate))
                                    .font(.subheadline)
                                    .foregroundColor(.grayColour)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
                        HStack {
                            Text("PRIORITY".localized())
                                .font(.system(size: 16, weight: .semibold))
                            
                            Spacer()
                            
                            Menu {
                                ForEach(GoalPriority.allCases, id: \.self) { level in
                                    Button(level.title) {
                                        if let goal = viewModel.goal {
                                            goalViewModel.changePriority(for: goal, to: level)
                                            viewModel.goal?.priority = level
                                        }
                                    }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(viewModel.goal?.priority.rawValue ?? "")
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                }
                            }
                            .padding(10)
                            .foregroundColor(viewModel.goal?.priority == .high ? .redColour : viewModel.goal?.priority == .medium ? .yellowColour : .greenColour)
                            .background(viewModel.goal?.priority == .high ? .redColour.opacity(0.18) : viewModel.goal?.priority == .medium ? .yellowColour.opacity(0.18) : .greenColour.opacity(0.18))
                            .cornerRadius(8)
                        }
                        
                        if let desc = viewModel.goal?.description {
                            Divider()
                                .padding(.vertical)
                            
                            VStack(alignment: .leading) {
                                Text("DESCRIPTION".localized())
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text(desc)
                                    .foregroundColor(.grayColour)
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .background(.whiteColour.opacity(0.08))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                }
            }
        }
        .defaultPage()
    }
}

#Preview {
    GoalDetailScreen(viewModel: GoalDetailViewModel())
}
