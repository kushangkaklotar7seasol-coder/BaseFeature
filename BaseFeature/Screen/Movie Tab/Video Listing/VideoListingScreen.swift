//
//  VideoListingScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import SwiftUI
import Kingfisher
import WebKit
struct SelectedVideo: Identifiable {
    let id = UUID()
    let url: URL
}
struct VideoListingScreen: View {
    var videos: [Video] = []
    var header: String = ""
    
    @State private var selectedVideo: SelectedVideo? = nil
    @State private var refreshID = UUID()
    var columns: [GridItem] {
        let count = Device.isiPadPortrait ? 3 : Device.isiPadLandscape ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
    }
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: header)
                
                ScrollView(showsIndicators: false) {
                    ForEach(videos.indices, id: \.self) { index in
                        let video = videos[index]
                        
                        ZStack {
                            KFImage.url(URL(string: "https://img.youtube.com/vi/\(video.key)/hqdefault.jpg"))
                                .placeholder({ progress in
                                    let placeHolderImage = "img_noimage"
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
                        .frame(width: screenWidth-32, height: Device.isiPadLandscape ? (screenHeight-150)/2 : (screenHeight-150)/3, alignment: .center)
                        .background()
                        .cornerRadius(24)
                        .onTapGesture {
                            if isYoutubeEnabled {
                                if let url = URL(string: "https://www.youtube.com/watch?v=\(video.key)") {
                                    selectedVideo = SelectedVideo(url: url)
                                }
                            }
                        }
                    }
                }
                .id(refreshID)

            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
        .sheet(item: $selectedVideo) { item in
            NavigationStack {
                CustomWebView(url: item.url)
                    .ignoresSafeArea(edges: .bottom)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                selectedVideo = nil
                            }
                            .fontWeight(.semibold)
                        }
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
    }
}

#Preview {
    VideoListingScreen()
}

struct CustomWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
