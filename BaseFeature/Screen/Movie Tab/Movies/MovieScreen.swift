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
    @StateObject var pagerState = MoviePagerState()
    @State var selectedSegment: Int = 0
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HomeDesign.MoviePagerview(viewModel: viewModel, pagerState: pagerState)
                    
                    CustomSegmentedControl(preselectedIndex: $selectedSegment)
                        .padding(.top, 8)
                        .id(localization.selectedLanguage)
                    
                    if selectedSegment == 0 {
                        if let bunch = viewModel.moviesBunchUpcoming {
                            DefaultDesign.MoviesBunch(moviedbunch: bunch, onViewMore: { media in
                                Router.shared.push(.movieListing(movieBunch: bunch))
                            })
                            .padding(.top, 24)
                            .id(localization.selectedLanguage)
                        }
                    } else {
                        if let bunch = viewModel.moviesBunchOnAir {
                            DefaultDesign.MoviesBunch(moviedbunch: bunch, onViewMore: { media in
                                Router.shared.push(.movieListing(movieBunch: bunch))
                            })
                            .padding(.top, 24)
                            .id(localization.selectedLanguage)
                        }
                    }
                    
                    if let array = viewModel.celebrity?.results {
                        DefaultDesign.SectionHeader(name: "CELEBRITY") {
                            Router.shared.push(.personListing(personDetail: viewModel.celebrity))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        .id(localization.selectedLanguage)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(array.indices, id: \.self) { index in
                                    let person = array[index]
                                    DefaultDesign.PersonPoster(id: person.id, url: person.profilePath ?? "", name: person.name)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    if selectedSegment == 0 {
                        if let bunch = viewModel.moviesBunchNewRelease {
                            DefaultDesign.MoviesBunch(moviedbunch: bunch, onViewMore: { media in
                                Router.shared.push(.movieListing(movieBunch: bunch))
                            })
                            .padding(.top, 24)
                            .id(localization.selectedLanguage)
                        }
                    } else {
                        if let bunch = viewModel.moviesBunchAiringToday {
                            DefaultDesign.MoviesBunch(moviedbunch: bunch, onViewMore: { media in
                                Router.shared.push(.movieListing(movieBunch: bunch))
                            })
                            .padding(.top, 24)
                            .id(localization.selectedLanguage)
                        }
                    }
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .top)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        Router.shared.push(.favouriteScreen)
                    } label: {
                        Image("ic_Heart_fill")
                            .resizable()
                            .frame(width: 16, height: 16, alignment: .center)
                            .padding(14)
                            .background(.whiteColour)
                            .cornerRadius(30)
                    }
                }
                .padding(.horizontal, 16)

                
                Spacer()
            }

        }
        .defaultPage()
    }
}

#Preview {
    MovieScreen()
}

class HomeDesign {
    struct MoviePagerview: View {
        @ObservedObject var viewModel: MovieViewModel
        @StateObject var pagerState: MoviePagerState
        @State private var refreshID = UUID()
        
        private var pagerHeight: CGFloat { screenHeight / 2.2 }
        
        private var pagerWidth: CGFloat {
            if Device.isiPadLandscape {
                return screenWidth - 400
            } else {
                return screenWidth
            }
        }
        
        var body: some View {
            ZStack(alignment: .bottom) {
                
                if !viewModel.topRatedMovie.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(viewModel.topRatedMovie.indices, id: \.self) { index in
                                let item = viewModel.topRatedMovie[index]
                                
                                ZStack(alignment: .bottom) {
                                    KFImage(URL(string: imageUrl + (item.posterPath ?? "")))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: pagerWidth, height: pagerHeight)
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
                                .frame(width: pagerWidth, height: pagerHeight)
                                .id(index)
                                .onTapGesture {
                                    Router.shared.push(.movieDetail(movieId: item.id, isMovie: true))
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $pagerState.scrollPosition)
                    .onChange(of: pagerState.scrollPosition) { _, newValue in
                        if let newValue {
                            pagerState.selectedIndex = newValue
                        }
                    }
                    .id(refreshID)
                    .onAppear {
                        restartTimerIfNeeded()
                    }
                    .onDisappear {
                        pagerState.stopAutoScroll()
                    }
                } else {
                    Color.clear
                        .frame(width: pagerWidth, height: pagerHeight)
                        .shimmer()
                }
                
                // Overlay Content
                if !viewModel.topRatedMovie.isEmpty {
                    let currentItem = viewModel.topRatedMovie[pagerState.selectedIndex % viewModel.topRatedMovie.count]
                    
                    VStack {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 12))
                                
                                Text(String(format: "%.1f", currentItem.voteAverage))
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                            
                            Text(currentItem.title)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(3)
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        let realCount = min(viewModel.topRatedMovie.prefix(5).count, 5)
                        let currentPageIndex = pagerState.selectedIndex % max(realCount, 1)
                        
                        HStack(spacing: 6) {
                            ForEach(0..<realCount, id: \.self) { idx in
                                Capsule()
                                    .fill(idx == currentPageIndex ? .leftTorightGradient : .grayGradient)
                                    .frame(width: idx == currentPageIndex ? 24 : 8, height: 8)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .id(refreshID)
                }
            }
            .frame(width: pagerWidth, height: pagerHeight)
            .cornerRadius(Device.isiPadLandscape ? 50 : 0)
            .padding(.top, Device.isiPadLandscape ? 20 : 0)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                refreshID = UUID()
            }
            .onChange(of: refreshID) { _, _ in
                restartTimerIfNeeded()
            }
        }
        
        private func restartTimerIfNeeded() {
            if !viewModel.topRatedMovie.isEmpty {
                pagerState.startAutoScroll(totalCount: viewModel.topRatedMovie.count) { _ in }
            }
        }
    }
}

class MoviePagerState: ObservableObject {
    @Published var scrollPosition: Int? = 0
    @Published var selectedIndex: Int = 0
    @Published var isLiked: Bool = true
    
    // Timer ne pan ahiya manage kari sakay
    private var timer: AnyCancellable?
    
    func startAutoScroll(totalCount: Int, onUpdate: @escaping (Int) -> Void) {
        timer?.cancel()
        timer = Timer.publish(every: 3.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, totalCount > 0 else { return }
                
                let next = (self.selectedIndex + 1) % totalCount
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.selectedIndex = next
                    self.scrollPosition = next
                }
            }
    }
    
    func stopAutoScroll() {
        timer?.cancel()
    }
}
