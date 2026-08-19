import Foundation
import SwiftUI

enum GoalCategory: String, CaseIterable, Codable {
    case work, personal, health, study, gym, sports, home, money, book

    var title: String {
        switch self {
        case .work: return "WORK"
        case .personal: return "PERSONAL"
        case .health: return "HEALTH"
        case .study: return "STUDY"
        case .gym: return "GYM"
        case .sports: return "SPORTS"
        case .home: return "HOME"
        case .money: return "MONEY"
        case .book: return "BOOK"
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
        case .high: return .redColour
        case .medium: return .yellowColour
        case .low: return .greenColour
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
        case .inProgress: return "IN_PROGRESS".localized()
        case .done: return "DONE".localized()
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
