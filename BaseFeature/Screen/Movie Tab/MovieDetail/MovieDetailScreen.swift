//
//  MovieDetailScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import SwiftUI
import Kingfisher
import WebKit

struct MovieDetailScreen: View {
    @StateObject var viewModel = MovieDetailViewModel()
    @State private var refreshID = UUID()
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    TopView
                        .id(refreshID)
                    
                    if let overView = viewModel.movieDetail?.overview, overView != "" {
                        DefaultDesign.SectionHeader(name: "OVERVIEW", isShowButton: false)
                            .padding(.horizontal, 16)
                            .id(refreshID)
                        
                        DefaultDesign.ExpandableTextView(text: overView)
                            .padding(.horizontal, 16)
                            .id(refreshID)
                    }
                    
                    if let director = viewModel.directorDetail {
                        HStack {
                            KFImage(URL(string: imageUrl + (director.profilePath ?? "")))
                                .placeholder({ Progress in
                                    Image("ic_no_person")
                                        .resizable()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .background(.grayColour)
                                })
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80, alignment: .center)
                                .cornerRadius(80)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(director.name)
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text(director.department)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.grayColour)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.grayColour)
                        }
                        .padding()
                        .background(.iconBackgroundColour)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        .onTapGesture {
                            Router.shared.push(.castDetail(celebrityId: director.id))
                        }
                    }
                    
                    if let cast = viewModel.movieCredits?.cast, !cast.isEmpty {
                        DefaultDesign.SectionHeader(name: "TOP_CAST") {
                            Router.shared.push(.castCrewListing(cast: cast, header: "\(viewModel.movieDetail?.title ?? viewModel.movieDetail?.name ?? "")"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(cast.indices, id: \.self) { index in
                                    let person = cast[index]
                                    DefaultDesign.PersonPoster(id: person.id, url: person.profilePath ?? "", name: person.name)
                                    // .onTapGesture {
                                    //        Router.shared.push(.artistDetail(artistId: person.id))
                                    // }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    if let video = viewModel.movieVideo?.results, !video.isEmpty {
                        DefaultDesign.SectionHeader(name: "TRAILER_CLIPS") {
                            Router.shared.push(.videoListing(videos: video, header: "\(viewModel.movieDetail?.title ?? viewModel.movieDetail?.name ?? "")"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(video, id: \.key) { video in
                                    ZStack {
                                        KFImage.url(URL(string: "https://img.youtube.com/vi/\(video.key)/hqdefault.jpg"))
                                            .placeholder({ progress in
                                                let placeHolderImage = "ic_noImage"
                                                Image(placeHolderImage)
                                                    .resizable()
                                                    .scaledToFill()
                                            })
                                            .resizable()
                                            .scaledToFill()
                                        
                                        if isYoutubeEnabled {
                                            Image(systemName: "play.fill")
                                                .padding(10)
                                                .background(.iconBackgroundColour)
                                                .cornerRadius(20)
                                        }
                                    }
                                    .frame(width: Device.isIpad ? (screenWidth-32)/3 : (screenWidth-32)/2, height: Device.isIpad ? (screenWidth-32)/3.5 : (screenWidth-32)/2.5, alignment: .center)
                                    .background()
                                    .cornerRadius(14)
                                    .onTapGesture {
                                        if isYoutubeEnabled {
                                            viewModel.youtubeUrl = "https://www.youtube.com/watch?v=\(video.key)"
                                            viewModel.isYoutubeVideo = true
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 50)
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                DefaultDesign.Header(name: "")
                    .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .defaultPage()
        .sheet(isPresented: $viewModel.isYoutubeVideo) {
            NavigationStack {
                if #available(iOS 26.0, *) {
                    WebView(url: URL(string: viewModel.youtubeUrl)!)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("DONE".localized()) {
                                    viewModel.isYoutubeVideo = false
                                }
                            }
                        }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
    }
}

#Preview {
    MovieDetailScreen()
}

private extension MovieDetailScreen {
    
    var TopView: some View {
        ZStack(alignment: .bottom) {
            var pagerHeight: CGFloat {
                if Device.isLandscape {
                    return screenHeight / 2
                } else {
                   return screenHeight / 2.2
                }
            }
            
            ZStack(alignment: .bottom) {
                KFImage(URL(string: imageUrl + (viewModel.movieDetail?.backdropPath ?? "")))
                    .resizable()
                    .placeholder({ Progress in
                        Image("ic_no_person")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.grayColour)
                    })
                    .scaledToFill()
                    .frame(width: Device.isiPadLandscape ? screenWidth-400 : screenWidth, height: pagerHeight)
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
            .frame(width: Device.isiPadLandscape ? screenWidth-400 : screenWidth, height: pagerHeight)
            
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                            
                            let star = (viewModel.movieDetail?.voteAverage ?? 0.0)/2
                            Text("\(star)".prefix(3))
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                        
                        HStack(spacing: 4) {
                            Text(viewModel.movieDetail?.releaseDate ?? viewModel.movieDetail?.firstAirDate ?? "")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.whiteColour)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                    }
                    
                    // Movie Title
                    Text("\(viewModel.movieDetail?.title ?? viewModel.movieDetail?.name ?? "")")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    
                    if let geners = viewModel.movieDetail?.genres {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(geners.indices, id: \.self) { index in
                                    if index != 0 {
                                        Circle()
                                            .fill(.grayColour)
                                            .frame(width: 8, height: 8)
                                    }
                                    
                                    Text(geners[index].name)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.grayColour)
                                }
                            }
                        }
                    }
                    
                    // Bottom Actions Row
                    HStack(spacing: 12) {
                        if isYoutubeEnabled {
                            DefaultDesign.FullScreenButton(name: "WATCH_TRAILER", onClick: {
                                viewModel.setTrailer()
                                viewModel.isYoutubeVideo = true
                            })
                        }
                        
                        DefaultDesign.IconButton(icon: viewModel.isLiked ? "ic_Heart_fill" : "ic_heart", onClick: {
                            Utility.addHaptics()
                            viewModel.manageLike()
                        })
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
    }
}
