//
//  TabBar.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

enum TabItem: CaseIterable {
    case home
    case movies
    case search
    case setting

    var icon: String {
        switch self {
        case .home: return "ic_home"
        case .movies: return "ic_movie"
        case .search: return "ic_search"
        case .setting: return "ic_setting"
        }
    }
}


struct TabBar: View {
    @State private var selectedTab: TabItem = .home
    @State private var loadedTabs: Set<TabItem> = [.home]
    @State private var showRateAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Active View Container using ZStack
            ZStack {
                if loadedTabs.contains(.home) {
                    HomeScreen()
                        .opacity(selectedTab == .home ? 1 : 0)
                        .allowsHitTesting(selectedTab == .home)
                }
                
                if loadedTabs.contains(.movies) {
                    MovieScreen()
                        .opacity(selectedTab == .movies ? 1 : 0)
                        .allowsHitTesting(selectedTab == .movies)
                }
                
                if loadedTabs.contains(.search) {
                    SearchScreen()
                        .opacity(selectedTab == .search ? 1 : 0)
                        .allowsHitTesting(selectedTab == .search)
                }
                
                if loadedTabs.contains(.setting) {
                    SettingScreen()
                        .opacity(selectedTab == .setting ? 1 : 0)
                        .allowsHitTesting(selectedTab == .setting)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
                .background(Color.blackColour)
            
            CustomTabBar(selectedTab: $selectedTab, loadedTabs: $loadedTabs)
                .background(Color.backgroundColour)
        }
        .background(Color.blackColour)
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)

    }
}

#Preview {
    TabBar()
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @Binding var loadedTabs: Set<TabItem>
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                    if !loadedTabs.contains(tab) {
                        loadedTabs.insert(tab)
                    }
                } label: {
                    ZStack {
                        Image(tab.icon)
                            .resizable()
                            .renderingMode(.template)
                            .tint(selectedTab == tab ? .leftTorightGradient : .grayGradient)
                            .frame(width: 24, height: 24)
                    }
                    .padding(12)
                    .background(.darkGray)
                    .cornerRadius(32)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
    }
}
