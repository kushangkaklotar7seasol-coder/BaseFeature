//
//  PersonDetailScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import SwiftUI
import Kingfisher

struct PersonDetailScreen: View {
    @StateObject var viewModel: PersonDetailViewModel
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack {
                        var imageSize: CGFloat {
                            return screenWidth/2.2
                        }
                        
                        ZStack {
                            KFImage(URL(string: imageUrl + (viewModel.celebrityDetail?.profilePath ?? "")))
                                .resizable()
                                .scaledToFill()
                                .frame(width: imageSize, height: imageSize)
                        }
                        .frame(width: imageSize, height: imageSize)
                        .shimmer()
                        .cornerRadius(imageSize)
                        
                        Text(viewModel.celebrityDetail?.name ?? "")
                            .font(.system(size: 28, weight: .bold))
                            .padding(.bottom, 2)
                        
                        HStack(spacing: 5) {
                            Image(systemName: "calendar")
                            
                            Text(viewModel.birthday ?? "")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(viewModel.personalDetail, id: \.id) { item in
                                    DefaultDesign.InformationBlock(text: item.value)
                                }
                            }
                            .frame(minWidth: screenWidth, alignment: .center)
                            .padding(.horizontal)
                        }
                        
                        if let about = viewModel.celebrityDetail?.biography, about != "" {
                            VStack(spacing: 12) {
                                DefaultDesign.SectionHeader(name: "ABOUT", isShowButton: false)
                                
                                DefaultDesign.ExpandableTextView(text: about)
                            }
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                        }
                        
                        if !(viewModel.movieCredits?.media.results.isEmpty ?? true) && !(viewModel.seriesCredits?.media.results.isEmpty ?? true)  {
                            CustomSegmentedControl(preselectedIndex: $viewModel.selectedSegment)
                                .padding(.top, 8)
                        }
                        
                        if viewModel.selectedSegment == 0 {
                            if let movie = viewModel.movieCredits {
                                DefaultDesign.MoviesBunch(moviedbunch: movie, onViewMore: { media in
                                    Router.shared.push(.movieListing(movieBunch: movie))
                                })
                                .padding(.top, 10)
                            }
                        } else {
                            if let movie = viewModel.seriesCredits {
                                DefaultDesign.MoviesBunch(moviedbunch: movie, onViewMore: { media in
                                    Router.shared.push(.movieListing(movieBunch: movie))
                                })
                                .padding(.top, 10)
                            }
                        }
                    }
                }
            }
            
            VStack {
                DefaultDesign.Header(name: "")
                    .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .defaultPage()
    }
}

#Preview {
    PersonDetailScreen(viewModel: PersonDetailViewModel())
}
