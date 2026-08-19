//
//  NewGoalScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//

import SwiftUI

struct NewGoalScreen: View {
    @StateObject var viewModel = NewGoalViewModel()

    /// Called with the new goal's database id right after it's saved
    var onGoalCreated: ((Int64) -> Void)? = nil

    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "ADD_NEW_GOAL")
                    .padding(.horizontal, 16)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        categorySection
                        
                        titleSection
                            .padding(.horizontal, 16)
                        descriptionSection
                            .padding(.horizontal, 16)
                        prioritySection
                            .padding(.horizontal, 16)
                        datesSection
                            .padding(.horizontal, 16)
                        
                        DefaultDesign.FullScreenButton(name: "CREATE", onClick: {
                            if let newId = viewModel.createGoal() {
                                onGoalCreated?(newId)
                                Router.shared.pop()
                            }
                        })
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }
            }
        }
        .defaultPage()
        .alert(viewModel.validationMessage, isPresented: $viewModel.showValidationError) {
            Button("OK", role: .cancel) {}
        }
    }

    // MARK: - Choose Category
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CHOOSE_CATEGORY".localized())
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(GoalCategory.allCases, id: \.self) { category in
                        CategoryIconView(
                            category: category,
                            isSelected: viewModel.selectedCategory == category
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Goal Title
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("GOAL_TITLE".localized())
                .font(.headline)
                .foregroundColor(.white)

            TextField("", text: $viewModel.title, prompt: Text("EG_RUN".localized()).foregroundColor(.gray))
                .foregroundColor(.white)
                .padding(14)
                .background(Color.white.opacity(0.08))
                .cornerRadius(12)
        }
    }

    // MARK: - Description
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DESCRIPTION".localized())
                .font(.headline)
                .foregroundColor(.white)

            ZStack(alignment: .topLeading) {
                if viewModel.description.isEmpty {
                    Text("DESCRIPTION_INFO".localized())
                        .foregroundColor(.gray)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 20)
                }

                TextEditor(text: $viewModel.description)
                    .scrollContentBackground(.hidden)
                    .foregroundColor(.white)
                    .padding(10)
                    .frame(height: 100)
            }
            .background(Color.white.opacity(0.08))
            .cornerRadius(12)
        }
    }

    // MARK: - Priority (custom segmented control, not a slider)
    private var prioritySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PRIORITY".localized())
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 0) {
                ForEach(GoalPriority.allCases, id: \.self) { level in
                    let isSelected = viewModel.priority == level
                    
                    Text(level.title)
                        .font(.subheadline.bold())
                        .foregroundColor(isSelected ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isSelected ? .leftTorightGradient : .clearGradient)
                        .cornerRadius(10)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.priority = level
                        }
                }
            }
            .padding(4)
            .background(Color.white.opacity(0.08))
            .cornerRadius(14)
        }
    }

    // MARK: - Dates
    private var datesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DATES".localized())
                .font(.headline)
                .foregroundColor(.white)

            HStack(spacing: 12) {
                DateBox(title: "START_DATE", date: $viewModel.startDate)
                DateBox(title: "TARGET_DATE", date: $viewModel.targetDate)
            }
        }
    }
}

// MARK: - One category icon (circle + label), green checkmark badge when selected
struct CategoryIconView: View {
    let category: GoalCategory
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(category.color)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(category.icon)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    )
                    .overlay(
                        Circle().stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                    )

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                        .background(Circle().fill(Color.black))
                        .offset(x: 2, y: -2)
                }
            }
            .frame(width: 58, height: 58)

            Text(category.title.localized())
                .font(.caption2)
                .foregroundColor(.white.opacity(0.85))
        }
    }
}

// MARK: - One date field: shows the picked date, taps open a date picker sheet
struct DateBox: View {
    let title: String
    @Binding var date: Date
    @State private var showPicker = false

    private var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    var body: some View {
        Button {
            showPicker = true
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                Text(title.localized())
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                    Text(formatted)
                }
                .font(.subheadline.bold())
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Color.white.opacity(0.08))
            .cornerRadius(12)
        }
        .sheet(isPresented: $showPicker) {
            VStack {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()

                DefaultDesign.FullScreenButton(name: "Done", onClick: {
                    showPicker = false
                })
                .padding(.horizontal, 16)
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    NewGoalScreen()
}
