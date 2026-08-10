//
//  BaseFeatureApp.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

@main
struct BaseFeatureApp: App {
    @StateObject private var localization = LocalizationManager.shared
    @StateObject private var router = Router.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack(path: $router.path) {
                    destination(for: router.rootRoute)
                        .toolbar(.hidden, for: .navigationBar)
                        .preferredColorScheme(.dark)
                        .navigationDestination(for: Route.self) { route in
                            destination(for: route)
                        }
                }
                .environment(\.locale, Locale(identifier: localization.selectedLanguage))
                .environmentObject(localization)
            }
            .toastManager()
        }
    }
}
