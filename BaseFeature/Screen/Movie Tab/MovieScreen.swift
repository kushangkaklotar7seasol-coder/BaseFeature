//
//  MovieScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI
import Kingfisher
import Combine

struct MovieScreen: View {
    @StateObject var viewModel = MovieViewModel()
    @State var selectedSegment: Int = 0
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HomeDesign.MoviePagerview(viewModel: viewModel)
                    
                    CustomSegmentedControl(preselectedIndex: $selectedSegment)
                        .padding(.top, 8)
                    
                    if selectedSegment == 0 {
                        if let bunch = viewModel.moviesBunchUpcoming {
                            DefaultDesign.MoviesBunch(moviedbunch: bunch, onViewMore: { media in
                                //Router.shared.push(.movieList(movieBunch: bunch))
                            })
                            .padding(.top, 24)
                        }
                    } else {
                        if let bunch = viewModel.moviesBunchOnAir {
                            DefaultDesign.MoviesBunch(moviedbunch: bunch, onViewMore: { media in
                                //Router.shared.push(.movieList(movieBunch: bunch))
                            })
                            .padding(.top, 24)
                        }
                    }
                    
                    if let array = viewModel.celebrity?.results {
                        DefaultDesign.SectionHeader(name: "Celebrity") {
                            // Router.shared.push(.artist(artistDetail: viewModel.celebrity))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(array.indices, id: \.self) { index in
                                    let person = array[index]
                                    DefaultDesign.PersonPoster(url: person.profilePath ?? "", name: person.name)
                                    // .onTapGesture {
                                    //        Router.shared.push(.artistDetail(artistId: person.id))
                                    // }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        if let bunch = viewModel.moviesBunch {
                            DefaultDesign.MoviesBunch(moviedbunch: bunch, onViewMore: { media in
                                // Router.shared.push(.movieList(movieBunch: bunch))
                            })
                            .padding(.top, 24)
                            //.id(localization.selectedLanguage)
                        }
                    }
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .defaultPage()
    }
}

#Preview {
    MovieScreen()
}

class HomeDesign {
    struct MoviePagerview: View {
        @State private var scrollPosition: Int? = 0
        @State private var selectedIndex: Int = 0
        @ObservedObject var viewModel: MovieViewModel
        
        @State private var timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
        
        private var screenWidth: CGFloat { UIScreen.main.bounds.width }
        private var screenHeight: CGFloat { UIScreen.main.bounds.height }
        private var pagerHeight: CGFloat { screenHeight / 2.2 }
        
        var body: some View {
            ZStack(alignment: .bottom) {
                
                // MARK: - Horizontal Pager ScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(viewModel.topRatedMovie.indices, id: \.self) { index in
                            let item = viewModel.topRatedMovie[index]
                            
                            ZStack(alignment: .bottom) {
                                KFImage(URL(string: imageUrl + (item.posterPath ?? "")))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth, height: pagerHeight)
                                    .clipped()
                                
                                LinearGradient(
                                    colors: [
                                        Color.black.opacity(0.0),
                                        Color.black.opacity(0.6),
                                        Color.black.opacity(0.95),
                                        Color.black
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: pagerHeight * 0.55)
                            }
                            .frame(width: screenWidth, height: pagerHeight)
                            .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $scrollPosition)
                .onChange(of: scrollPosition) { _, newValue in
                    if let newValue {
                        withAnimation() {
                            selectedIndex = newValue
                        }
                    }
                }
                .onReceive(timer) { _ in
                    guard !viewModel.topRatedMovie.isEmpty else { return }
                    
                    withAnimation(.easeInOut(duration: 0.5)) {
                        let nextIndex = (selectedIndex + 1) % viewModel.topRatedMovie.count
                        withAnimation() {
                            scrollPosition = nextIndex
                        }
                    }
                }
                
                // MARK: - Overlay Content (Top Icons & Bottom Controls)
                if !viewModel.topRatedMovie.isEmpty {
                    let currentItem = viewModel.topRatedMovie[selectedIndex % viewModel.topRatedMovie.count]
                    
                    VStack {
                        // Top Right Badges
                        HStack {
                            Spacer()
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 38, height: 38)
                                    .overlay(
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.red)
                                            .font(.system(size: 16))
                                    )
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 38, height: 38)
                                    .overlay(
                                        Image(systemName: "crown.fill")
                                            .foregroundColor(.orange)
                                            .font(.system(size: 16))
                                    )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 50)
                        
                        Spacer()
                        
                        // Bottom Info Section
                        VStack(alignment: .leading, spacing: 12) {
                            
                            // Rating Pill
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 12))
                                
                                Text(String(format: "%.1f", currentItem.voteAverage ?? 8.8))
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                            
                            // Movie Title
                            Text(currentItem.title ?? "")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Bottom Actions Row
                            HStack(spacing: 12) {
                                
                                // Watch Trailer Button
                                Button {
                                    // Action: Watch Trailer
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 12))
                                        Text("WATCH TRAILER")
                                            .font(.system(size: 13, weight: .bold))
                                    }
                                    .foregroundColor(.whiteColour)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 12)
                                    .background(.leftTorightGradient)
                                    .cornerRadius(8)
                                }
                                
                                // Heart Button
                                Button {
                                    // Action: Toggle Favorite
                                } label: {
                                    Image("ic_heart")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(.iconBackgroundColour)
                                        .cornerRadius(12)
                                }
                                
                                Spacer()
                                
                                // 💡 5 Page Indicators (Calculated with Modulo)
                                let realCount = min(viewModel.topRatedMovie.prefix(5).count, 5)
                                
                                let currentPageIndex = selectedIndex % (realCount > 0 ? realCount : 1)
                                
                                HStack(spacing: 6) {
                                    ForEach(0..<realCount, id: \.self) { idx in
                                        Capsule()
                                            .fill(idx == currentPageIndex ? .leftTorightGradient : .grayGradient)
                                            .frame(width: idx == currentPageIndex ? 24 : 8, height: 8)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
            }
            .frame(height: pagerHeight)
//            .background(.red)
        }
    }
}
