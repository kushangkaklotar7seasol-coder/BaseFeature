import Foundation
import SwiftUI

enum GoalCategory: String, CaseIterable, Codable {
    case work, personal, health, study, gym, sports, home, money, book

    var title: String {
        switch self {
        case .work: return "Work"
        case .personal: return "Personal"
        case .health: return "Health"
        case .study: return "Study"
        case .gym: return "Gym"
        case .sports: return "Sports"
        case .home: return "Home"
        case .money: return "Money"
        case .book: return "Book"
        }
    }

    var icon: String {
        switch self {
        case .work: return "ic_work"
        case .personal: return "ic_personal"
        case .health: return "ic_health"
        case .study: return "ic_study"
        case .gym: return "ic_gym"
        case .sports: return "ic_sports"
        case .home: return "ic_house"
        case .money: return "ic_money"
        case .book: return "ic_book"
        }
    }

    var color: Color {
        switch self {
        case .work: return Color.purple
        case .personal: return Color.cyan
        case .health: return Color.red
        case .study: return Color.orange
        case .gym: return Color.indigo
        case .sports: return Color.blue
        case .home: return Color.orange
        case .money: return Color.green
        case .book: return Color.purple
        }
    }
}

enum GoalPriority: String, CaseIterable, Codable {
    case low, medium, high

    var title: String {
        rawValue.capitalized
    }
    
    var badgeTextColor: Color {
        switch self {
        case .high: return Color(red: 1, green: 0.42, blue: 0.42)
        case .medium: return Color(red: 1, green: 0.75, blue: 0.35)
        case .low: return Color(red: 0.45, green: 0.85, blue: 0.55)
        }
    }
 
    var badgeBackgroundColor: Color {
        badgeTextColor.opacity(0.18)
    }
}

// Extra field requested: tracks whether a goal is still active or finished
enum GoalStatus: String, CaseIterable, Codable {
    case inProgress = "in_progress"
    case done = "done"

    var title: String {
        switch self {
        case .inProgress: return "In Progress"
        case .done: return "Done"
        }
    }
}

struct Goal: Identifiable, Equatable, Hashable {
    var id: Int64?
    var category: GoalCategory
    var title: String
    var description: String
    var priority: GoalPriority
    var status: GoalStatus
    var startDate: Date
    var targetDate: Date
    var createdAt: Date = Date()
}
