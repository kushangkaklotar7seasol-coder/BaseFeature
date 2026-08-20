//
//  MyGoalScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//

import SwiftUI
import Lottie

struct MyGoalScreen: View {
    @StateObject var viewModel = MyGoalViewModel()
    @StateObject var goalListViewModel = GoalsListViewModel()
    
    var body: some View {
        ZStack {
            
            VStack {
                DefaultDesign.Header(name: "GOAL_TRACKER".localized())
                    .padding(.horizontal, 16)
                
                    keepGoing
                        .padding(.horizontal, 16)
                    
                    HStack {
                        Button {
                            if viewModel.totalCount ?? 0 > 0 {
                                Router.shared.push(.goalList(displayType: 0))
                            }
                        } label: {
                            VStack {
                                Text("\(viewModel.totalCount ?? 0)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.lightPurple)
                                
                                Text("TOTAL_GOALS".localized())
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.grayColour)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(.iconBackgroundColour)
                            .cornerRadius(12)
                        }
                        
                        Button {
                            if viewModel.doneCount ?? 0 > 0 {
                                Router.shared.push(.goalList(displayType: 1))
                            }
                        } label: {
                            VStack {
                                Text("\(viewModel.doneCount ?? 0)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.greenColour)
                                
                                Text("COMPLETED".localized())
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.grayColour)
                                
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(.iconBackgroundColour)
                            .cornerRadius(12)
                        }
                        
                        Button {
                            if viewModel.inProgressCount ?? 0 > 0 {
                                Router.shared.push(.goalList(displayType: 2))
                            }
                        } label: {
                            VStack {
                                Text("\(viewModel.inProgressCount ?? 0)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.lightPurple)
                                
                                Text("IN_PROGRESS".localized())
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.grayColour)
                                
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(.iconBackgroundColour)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                if !viewModel.goals.isEmpty {
                    DefaultDesign.SectionHeader(name: "MY_GOALS".localized(), onClick: {
                        Router.shared.push(.goalList(displayType: 0))
                    })
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
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
                } else {
                    VStack(spacing: 8) {
                        Spacer()
                        Image("ic_goal_red")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                        
                        Text("YOUR_FIRST_GOAL_HEADER".localized())
                        
                        Text("YOUR_FIRST_GOAL".localized())//
                            .foregroundColor(.grayColour)
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            
//            if viewModel.goals.isEmpty {
//                VStack(spacing: 16) {
//                    Image("ic_goal_red")
//                        .resizable()
//                        .frame(width: 100, height: 100, alignment: .center)
//                    
//                    Text("YOUR_FIRST_GOAL".localized())
//                        .foregroundColor(.grayColour)
//                }
//            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        Router.shared.push(.newGoal)
                    } label: {
                        Image("ic_plus")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                            .padding(12)
                            .background(.leftTorightGradient)
                            .cornerRadius(25)
                    }
                }
            }
            .padding(26)
            .padding(.bottom, 30)
            
        }
        .defaultPage()
        .onAppear() {
            viewModel.getGoals()
        }
    }
    
    // MARK: - Goal Title
    private var keepGoing: some View {
            HStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Text("KEEP_GOING".localized())
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.whiteColour)
                    
                    Text("YOU_MAKING_GREAT_PROGRESS".localized())
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.grayColour)
                }
                
                Spacer()
                
                LottieView(animation: .named("goal_lottie"))
                    .looping()
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 8)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.whiteColour.opacity(0.08))
            .cornerRadius(12)
    }
}

#Preview {
    MyGoalScreen()
}

struct GoalCardView: View {
    let goal: Goal
    var isOnTapWork: Bool = true
    @ObservedObject var viewModel: GoalsListViewModel
    var onDelete: (()->Void)
 
    var body: some View {
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
                
                VStack {
                    Spacer()
                    Menu {
                        Button(role: .destructive) {
                            AlertManager.shared.show(
                                title: "DELETE_GOAL".localized(),
                                message: "DELETE_GOAL_INFO".localized(),
                                buttons: [
                                    AlertButtonModel(title: "CANCEL".localized(), role: .cancel),
                                    AlertButtonModel(title: "DELETE".localized(), role: .destructive) {
                                        viewModel.deleteGoal(goal)
                                        self.onDelete()
                                    }
                                ]
                            )
                        } label: {
                            Label("DELETE".localized(), systemImage: "trash")
                        }
                    } label: {
                        Image("ic_more")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                            .contentShape(Rectangle())
                    }
                    Spacer()
                }
            }
            .padding(14)
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .onTapGesture {
            if isOnTapWork {
                Router.shared.push(.goalDetail(goal: goal))
            }
        }
//        .contextMenu {
//            Button {
//                viewModel.toggleStatus(for: goal)
//            } label: {
//                Label(
//                    goal.status == .done ? "Mark In Progress" : "Mark Done",
//                    systemImage: goal.status == .done ? "arrow.uturn.left" : "checkmark.circle"
//                )
//            }
// 
//            Menu("Change Priority") {
//                ForEach(GoalPriority.allCases, id: \.self) { level in
//                    Button(level.title) {
//                        viewModel.changePriority(for: goal, to: level)
//                    }
//                }
//            }
// 
//            Button(role: .destructive) {
//                viewModel.deleteGoal(goal)
//            } label: {
//                Label("Delete", systemImage: "trash")
//            }
//        }
    }
}
