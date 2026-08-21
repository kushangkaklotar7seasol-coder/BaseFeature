//
//  SearchScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

struct SearchScreen: View {
    @StateObject var viewModel = SearchViewModel()
    @EnvironmentObject var localization: LocalizationManager
//    @State var selectedSegment: Int = 0
    @FocusState var isTextFieldFocused: Bool
//    let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
    @State private var refreshID = UUID()
    var columns: [GridItem] {
        let count = Device.isiPadPortrait ? 4 : Device.isiPadLandscape ? 5 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    VStack {
                        Spacer()
                        
                        ZStack { }
                        .frame(width: screenWidth, height: 20, alignment: .center)
                        .background(.myColour)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 20
                            )
                        )
                    }
                    
                    VStack {
                        HStack {
                            Image("ic_search_small")
                            
                            TextField("", text: $viewModel.searchTextField,
                                      prompt: Text("SEARCH_PLACEHOLDER".localized())
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(.grayColour)
                            )
                            .foregroundColor(.blackColour)
                            .focused($isTextFieldFocused)
                            .overlay(
                                HStack {
                                    Spacer()
                                    if !viewModel.searchTextField.isEmpty {
                                        Button(action: {
                                            self.viewModel.searchTextField = ""
                                            viewModel.movies = []
                                            viewModel.series = []
                                            viewModel.moviesResponse = nil
                                            viewModel.seriesResponse = nil
                                        }) {
                                            Image(systemName: "multiply.circle.fill")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 8)
                                        }
                                    }
                                }
                            )
                        }
                        .padding()
                        .background(.whiteColour)
                        .cornerRadius(26)
                        .padding(.horizontal, 16)
                        .id(localization.selectedLanguage)
                        
                        CustomSegmentedControl(preselectedIndex: $viewModel.selectedSegment, onSelect: { index in
                            viewModel.manageAPICalls(index: index)
                        })
                        .padding(.top, 8)
                        .id(localization.selectedLanguage)
                    }
                }
                .frame(width: screenWidth, height: screenHeight/4.5, alignment: .center)
                .background(LinearGradient(colors: [.darkBabyPinkColour.opacity(0.5), .lightPurple.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                
                
                let array = viewModel.selectedSegment == 0 ? viewModel.movies : viewModel.series
                
                if !array.isEmpty {
                    VStack {
                        if viewModel.selectedSegment == 0 {
                            ScrollView(showsIndicators: false) {
                                LazyVGrid(columns: columns) {
                                    ForEach(array.indices, id: \.self) { index in
                                        DefaultDesign.MovieCard(movies: array[index])
                                            .onAppear() {
                                                self.loadMoreIfNeeded(currentItem: index)
                                            }
                                    }
                                }
                                .padding(.vertical, 20)
                            }
                            .scrollDismissesKeyboard(.immediately)
                            .id(refreshID)
                        } else {
                            ScrollView(showsIndicators: false) {
                                
                                LazyVGrid(columns: columns) {
                                    ForEach(array.indices, id: \.self) { index in
                                        DefaultDesign.MovieCard(movies: array[index])
                                            .onAppear() {
                                                self.loadMoreIfNeeded(currentItem: index)
                                            }
                                    }
                                }
                                .padding(.vertical, 20)
                                
                            }
                            .scrollDismissesKeyboard(.immediately)
                            .id(refreshID)
                        }
                    }
                    .id(localization.selectedLanguage)
                    
                } else {
                    VStack {
                        VStack(spacing: 16) {
                            if viewModel.searchTextField.isEmpty {
                                Image("ic_search_empty_background")
                                    .resizable()
                                    .frame(width: 93, height: 120, alignment: .center)
                                
                                Text("EMPTY_SCREEN".localized())
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.whiteColour)
                                    .multilineTextAlignment(.center)
                                
                                Text("EMPTY_SCREEN_INFO".localized())
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.grayColour)
                                    .multilineTextAlignment(.center)
                                
                            } else {
                                Image("ic_search_empty_background")
                                    .resizable()
                                    .frame(width: 93, height: 120, alignment: .center)
                                
                                Text("NO_SEARCH_FOUND".localized())
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.whiteColour)
                                    .multilineTextAlignment(.center)
                                
                                Text("\("NO_SEARCH_FOUND_FOR".localized()) \(viewModel.searchTextField)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.grayColour)
                                    .multilineTextAlignment(.center)
                            }
                            
                        }
                        .opacity(0.4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(y: -viewModel.keyboardHeight / 3 - 64)
                    }
                    .frame(maxWidth: .infinity)
                    .id(refreshID)
                    .id(localization.selectedLanguage)
                }
                
                
                Spacer()
            }
        }
        .defaultPage()
        .edgesIgnoringSafeArea(.bottom)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture {
            isTextFieldFocused = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeOut(duration: 0.25)) {
                    viewModel.keyboardHeight = keyboardFrame.height
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeOut(duration: 0.25)) {
                viewModel.keyboardHeight = 0
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        if viewModel.selectedSegment == 0 {
            guard !viewModel.isLoading, currentItem == viewModel.movies.count - 5 else { return }
            viewModel.moviesSearchAPI(text: viewModel.searchTextField, isFromPagination: true)
        } else {
            guard !viewModel.isLoading, currentItem == viewModel.series.count - 5 else { return }
            viewModel.searchSeriesAPI(text: viewModel.searchTextField, isFromPagination: true)
        }
    }
}

#Preview {
    SearchScreen()
}
