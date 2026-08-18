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
                DefaultDesign.Header(name: "Goal Tracker")
                    .padding(.horizontal, 16)
                
                if !viewModel.goals.isEmpty {
                    keepGoing
                        .padding(.horizontal, 16)
                    
                    DefaultDesign.SectionHeader(name: "My Goals", onClick: {
                        Router.shared.push(.goalList)
                    })
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 14) {
                            ForEach(viewModel.goals) { goal in
                                GoalCardView(goal: goal)
                            }
                        }
                        .padding(.bottom, 80)
                    }
                    
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            
            if viewModel.goals.isEmpty {
                VStack(spacing: 16) {
                    Image("ic_goal_red")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                    
                    Text("Set Your First Goal")
                        .foregroundColor(.grayColour)
                }
            }
            
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
                    Text("Keep going")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.whiteColour)
                    
                    Text("You are making great progress")
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
//    @ObservedObject var viewModel: GoalsListViewModel
 
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
                        Text(formattedDueText(for: goal.targetDate))
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
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .onTapGesture {
            Router.shared.push(.goalDetail(goal: goal))
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
 
    private func formattedDueText(for date: Date) -> String {
        let calendar = Calendar.current
 
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: date)
 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
 
        if calendar.isDateInToday(date) {
            return "Due Today, \(timeString)"
        } else if calendar.isDateInTomorrow(date) {
            return "Due Tomorrow, \(timeString)"
        } else if date < Date() {
            return "Overdue, \(dateFormatter.string(from: date))"
        } else {
            return "Due \(dateFormatter.string(from: date)), \(timeString)"
        }
    }
}
