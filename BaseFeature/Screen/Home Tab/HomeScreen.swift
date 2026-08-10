//
//  HomeScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

struct HomeScreen: View {
    
    var columns: [GridItem] {
        let count = Device.isIpad ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("All")
                        .foregroundColor(.whiteColour)
                        .font(.system(size: 30, weight: .bold))
                        
                   + Text(" Tools")
                        .foregroundColor(.lightPurple)
                        .font(.system(size: 30, weight: .bold))
                 
                    Spacer()
                }
                
                ZStack {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Storage")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.whiteColour)
                                
                                Text("128 GB Total")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.grayColour)
                            }
                            
                            Spacer()
                            
                            Image("ic_right_arrow")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                                .padding(10)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 30)
                                        .strokeBorder(.whiteColour.opacity(0.2))
                                }
                        }
                        .padding(.horizontal, 14)
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.whiteColour.opacity(0.08))
                .cornerRadius(12)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(.whiteColour.opacity(0.2))
                }
                    
                HStack() {
                    Text("Quick Tools")
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                
                var toolwidth: CGFloat {
                    return (screenWidth-36)/2
                }
                
                LazyVGrid(columns: columns) {
                    ForEach(0...3, id: \.self) { person in
                        ZStack {
                            VStack(alignment: .leading) {
                                ZStack { }
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .background()
                                    .cornerRadius(25)
                                
                                Text("Goal Tracker")
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text("Set goals, track progress and achieve more.")
                                    .font(.system(size: 12, weight: .regular))
                                    .padding(.top, 1)
                            }
                            .padding(8)
                        }
                        .frame(width: toolwidth, height: 130, alignment: .center)
                        .background(.whiteColour.opacity(0.08))
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
    }
}

#Preview {
    HomeScreen()
}
