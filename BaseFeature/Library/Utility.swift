//
//  Utility.swift
//  Korvani
//
//  Created by Kushang kaklotar on 11/07/26.
//

import Foundation
import UIKit

class Utility {
    static let shared = Utility()
    
    // MARK: - Internet -
    class func isInternetAvailable() -> Bool{
        var  isAvailable : Bool
        isAvailable = true
        let reachability = try? Reachability() //try? Reachability(hostname: "google.com") //Reachability()
        if(reachability?.connection == Reachability.Connection.unavailable)
        {
            isAvailable = false
        }
        else
        {
            isAvailable = true
        }
        
        return isAvailable
    }

    class func getWeatherImageUrl(_ code: String) -> String {
        return "https://openweathermap.org/img/wn/\(code)@2x.png"
    }
    
    class func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    class func shareText(_ text: String) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        rootViewController.present(activityVC, animated: true)
    }
    
    class func addHaptics(){
        let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
    }
    
    class func openAppPermissionSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    class func formattedDueText(for date: Date) -> String {
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

