//
//  Splash.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI
import Lottie
import Kingfisher

struct Splash: View {
    @StateObject var viewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            Image("img_splash")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("app_icon")
                    .resizable()
                    .frame(width: 110, height: 110, alignment: .center)
                
                Text("Cinevora")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.whiteColour)
            }
            
            VStack {
                Spacer()
                
                LottieView(animation: .named("loading_lottie"))
                    .looping()
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            .padding(.vertical, 50)
        }
        .defaultPage()
        .onAppear() {
            viewModel.webservice_getJSON_api() {}
            
            viewModel.requestTrackingPermission() {
                viewModel.navigationManager()
            }
        }
    }
}

#Preview {
    Splash()
}

class DefaultDesign {
    
    struct Header: View {
        let name: String
        var showBackbutton: Bool = true
        var secondButton: String = ""
        var secondbuttonForegroundColour: Color = .lightPurple
        var onSecondButtonClick: (()->Void)?
        
        var body: some View {
            HStack {
                HStack {
                    if showBackbutton {
                        Button {
                            Router.shared.pop()
                        } label: {
                            Image("ic_back")
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .center)
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: 55)
                
                Spacer()
                
                Text(name.localized())
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.whiteColour)
                
                Spacer()
                
                ZStack {
                    Button {
                        self.onSecondButtonClick?()
                    } label: {
                        Text(secondButton.localized())
                            .foregroundColor(secondbuttonForegroundColour)
                    }
                }
                .frame(width: 55, height: 30, alignment: .center)
            }
        }
    }
    
    struct FullScreenButton: View {
        let name: String
        var onClick: (()->Void?)
        
        var body: some View {
            Button {
                self.onClick()
            } label: {
                Text(name.localized())
                    .padding()
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.whiteColour)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 44)
                    .background(.leftTorightGradient)
                    .cornerRadius(10)
            }
        }
    }
    
    struct IconButton: View {
        var icon: String
        var systemImage: String = ""
        var onClick: (()->Void?)
        
        var body: some View {
            Button {
                self.onClick()
            } label: {
                if !icon.isEmpty {
                    Image(icon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: systemImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                }
            }
            .frame(width: 44, height: 44)
            .background(.iconBackgroundColour)
            .cornerRadius(12)
        }
    }
    
    struct InformationBlock: View {
        var text: String
        
        var body: some View {
            HStack(spacing: 4) {
                Text(text)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.whiteColour)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.2))
            .clipShape(Capsule())
        }
    }
    
    struct GradientBullet: View {
        var body: some View {
            ZStack { }
                .frame(width: 8, height: 8, alignment: .center)
                .background(.strongPrimeGradient)
                .cornerRadius(8)
        }
    }
    
    struct CustomBullet: View {
        let Color: Color
        
        var body: some View {
            ZStack { }
                .frame(width: 8, height: 8, alignment: .center)
                .background(Color)
                .cornerRadius(8)
        }
    }
    
    struct ImageView: View {

        let url: String
        var width: CGFloat? = nil
        var height: CGFloat
        var cornerRadius: CGFloat = 0
        var placeholderHeight: CGFloat = 0
        var placeholderImage: String? = nil

        @State private var isFailed: Bool = false

        var body: some View {

            ZStack {

                if isFailed {
                    if let image = placeholderImage {
                        let placeHeight = placeholderHeight == 0 ? height : placeholderHeight
                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: placeHeight, height: placeHeight)
                            .frame(width: width, height: height)
                            .frame(maxWidth: width == nil ? .infinity : nil)
                            .background(.grayColour.opacity(0.5))
                    } else {
                        Color.white.opacity(0.3)
                    }
                } else {
                    KFImage(URL(string: url))
                        .onFailure { _ in
                            isFailed = true
                        }
//                        .placeholder {
//                            ZStack {
//                                Color(.grayColour.opacity(0.5))
//                                ProgressView()
//                            }
//                        }
                        .fade(duration: 0.25)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .shimmer()
                }
            }
            .frame(width: width, height: height)
            .frame(maxWidth: width == nil ? .infinity : nil)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
    
    struct SectionHeader: View {
        var name: String = ""
        var buttonName: String = "SEE_ALL"
        var isShowButton: Bool  = true
        var onClick: (()->Void)?
        
        var body: some View {
            HStack {
                Text(name.localized())
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.whiteColour)
                
                Spacer()
                
                if isShowButton {
                    Button {
                        self.onClick?()
                    } label: {
                        HStack(spacing: 4) {
                            Text(buttonName.localized())
                                .font(.system(size: 13, weight: .semibold))
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.grayColour)
                    }
                }
            }
        }
    }
    
    struct PersonPoster: View {
        var id: Int
        var url: String = ""
        var name: String = ""
        
        var posterSize: CGFloat {
            if Device.isiPadPortrait {
                return screenWidth/6
            } else if Device.isLandscape {
                return screenWidth/7
            } else {
                return screenWidth/4
            }
        }
        
        var body: some View {
            VStack(spacing: 8) {
                ZStack {
                    ZStack {
                        DefaultDesign.ImageView(url: imageUrl+url, width: posterSize-10, height: posterSize-10, placeholderHeight: 50, placeholderImage: "ic_no_person")
                    }
                    .frame(maxWidth: posterSize, maxHeight: posterSize)
                    .background(.whiteColour)
                    .cornerRadius((posterSize-10)/2 )
                    .padding()
                }
                .frame(width: posterSize, height: posterSize, alignment: .center)
                .cornerRadius(posterSize/2)
                
                Text(name)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.grayColour)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: posterSize)
            .onTapGesture {
                Router.shared.push(.castDetail(celebrityId: id))
            }
        }
    }
    
    struct MovieCard: View {
        var movies: MediaItem
        var isShowLike = true
        var onLike: ((MediaItem) -> Void)?
        var onClick: (() -> Void)?
        @State var isLiked: Bool = false
        
        var width: CGFloat {
            if Device.isiPadPortrait {
                return screenWidth/4.5
            } else if Device.isiPadLandscape {
                return screenWidth/5.5
            } else {
                return screenWidth/2.5
            }
        }
        
        var height: CGFloat {
            return width*1.3
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                ZStack {
                    DefaultDesign.ImageView(url: imageUrl+(movies.posterPath ?? ""), width: width, height: height, placeholderHeight: 50, placeholderImage: "ic_no_movie")
                    
                    VStack {
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                Utility.addHaptics()
                                if self.isLiked {
                                    database.removeMovie(id: movies.id)
                                } else {
                                    database.addMovie(movies)
                                }
                                
                                self.isLiked.toggle()
                                
                                onLike?(self.movies)
                            } label: {
                                Image(self.isLiked ? "ic_Heart_fill" : "ic_heart")
                                    .resizable()
                                    .frame(width: 15, height: 15, alignment: .center)
                                    .padding(10)
                                    .background(.iconBackgroundColour)
                                    .cornerRadius(30)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(10)
                }
                .frame(width: width, height: height, alignment: .center)
                .cornerRadius(8)
                
                Text((movies.title ?? movies.name) ?? "")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.whiteColour)
                    .lineLimit(1)
                
                HStack(spacing: 5) {
                    if let releaseDate = (movies.releaseDate ?? movies.firstAirDate) {
                        Text(releaseDate)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.grayColour)
                            .lineLimit(1)
                    }
                    
                    Spacer()

                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    
                    Text("4.5")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.grayColour)
                        .lineLimit(1)
                }
            }
            .frame(width: width, alignment: .center)
            .onTapGesture {
                onClick?()
                Utility.closeKeyboard()
                Router.shared.push(.movieDetail(movieId: movies.id, isMovie: movies.title != nil ? true : false))
            }
            .onAppear() {
                self.isLiked = database.isMovieLiked(id: movies.id)
            }
        }
    }
    
    struct MoviesBunch: View {
        let moviedbunch: MediaBunch
        var onViewMore: ((MediaBunch)->Void)?
        var onMedia: ((MediaItem)->Void)?
        
        var body: some View {
            VStack {
                DefaultDesign.SectionHeader(name: moviedbunch.name) {
                    self.onViewMore?(moviedbunch)
                }
                .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(moviedbunch.media.results.indices, id: \.self) { index in
                            let movie = moviedbunch.media.results[index]
                            MovieCard(movies: movie)
                                .onTapGesture {
                                    self.onMedia?(movie)
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    struct ExpandableTextView: View {
        let text: String
        
        @State private var isExpanded = false
        @State private var isTruncated = false
        @State private var fullHeight: CGFloat = 0
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(text)
                    .foregroundColor(.gray)
                    .lineLimit(isExpanded ? nil : 3)
                    .multilineTextAlignment(.leading)
                    .background(
                        // Only measure full height (never changes)
                        Text(text)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .hidden()
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            fullHeight = geo.size.height
                                            checkTruncation()
                                        }
                                        .onChange(of: geo.size.height) { _, newHeight in
                                            fullHeight = newHeight
                                            checkTruncation()
                                        }
                                }
                            )
                    )
                    .animation(.easeInOut(duration: 0.25), value: isExpanded)
                
                if isTruncated {
                    Button {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Text(isExpanded ? "SHOW_LESS".localized() : "SHOW_MORE".localized())
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.whiteColour)
                            
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .resizable()
                                .frame(width: 12, height: 8)
                        }
                    }
                }
            }
            .onChange(of: text) { _, _ in
                isExpanded = false
                isTruncated = false
                fullHeight = 0
            }
        }
        
        private func checkTruncation() {
            guard fullHeight > 0 else { return }
            
            // 3 line ni approximate height
            let font = UIFont.systemFont(ofSize: 17)
            let threeLineHeight = font.lineHeight * 3 + 6
            
            let shouldTruncate = fullHeight > threeLineHeight
            
            // Only set once (important)
            if shouldTruncate && !isTruncated {
                isTruncated = true
            }
        }
    }
    
//    struct ExpandableTextView: View {
//        let text: String
//        
//        @State private var isExpanded = false
//        @State private var isTruncated = false
//        
//        var body: some View {
//            VStack(alignment: .leading, spacing: 4) {
//                Text(text)
//                    .foregroundColor(.gray)
//                    .lineLimit(isExpanded ? nil : 3)
//                    .multilineTextAlignment(.leading)
//                    .background(
//                        Text(text)
//                            .lineLimit(nil)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .hidden()
//                            .background(
//                                GeometryReader { fullGeometry in
//                                    Color.clear
//                                        .onAppear {
//                                            checkTruncation(fullHeight: fullGeometry.size.height)
//                                        }
//                                }
//                            )
//                    )
//                    .animation(.easeInOut, value: isExpanded)
//                
//                if isTruncated {
//                    
//                    Button {
//                        withAnimation {
//                            isExpanded.toggle()
//                        }
//                    } label: {
//                        HStack(spacing: 5) {
//                            Text(isExpanded ? "SHOW_LESS".localized() : "SHOW_MORE".localized())
//                                .font(.system(size: 14, weight: .medium))
//                                .foregroundColor(.whiteColour)
//                            
//                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
//                                .resizable()
//                                .frame(width: 12, height: 8, alignment: .center)
//                        }
//                    }
//                }
//            }
//            .onChange(of: text) { _ in
//                isExpanded = false
//                isTruncated = false
//            }
//        }
//        
//        private func checkTruncation(fullHeight: CGFloat) {
//            let lineHeight = UIFont.systemFont(ofSize: 17).lineHeight
//            let calculatedTruncated = fullHeight > lineHeight * 3.2
//            if calculatedTruncated != isTruncated {
//                isTruncated = calculatedTruncated
//            }
//        }
//    }
}
