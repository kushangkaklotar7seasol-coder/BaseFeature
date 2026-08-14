//
//  SearchScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

struct SearchScreen: View {
    @StateObject var viewModel = SearchViewModel()
    @State var selectedSegment: Int = 0
    @FocusState var isTextFieldFocused: Bool
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                            Image("ic_search")
                            
                            TextField("Search for Movie/TV Show", text: $viewModel.searchTextField)
                                .foregroundColor(.blackColour)
                                .focused($isTextFieldFocused)
                        }
                        .padding()
                        .background(.whiteColour)
                        .cornerRadius(26)
                        .padding(.horizontal, 16)
                        
                        CustomSegmentedControl(preselectedIndex: $selectedSegment, onSelect: { index in
                            viewModel.manageAPICalls(index: index)
                        })
                        .padding(.top, 8)
                    }
                }
                .frame(width: screenWidth, height: screenHeight/4.5, alignment: .center)
                .background(.leftTorightGradient)
                
                
                let array = viewModel.selectedIndex == 0 ? viewModel.movies : viewModel.series
                
                if !array.isEmpty {
                    VStack {
                        if viewModel.selectedIndex == 0 {
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
                            
                        }
                    }
                    
                } else {
                    VStack {
                        VStack(spacing: 16) {
                            if viewModel.searchTextField.isEmpty {
                                Image("ic_search_empty_background")
                                    .resizable()
                                    .frame(width: 93, height: 120, alignment: .center)
                                
                                Text("Strings.searchMoviePlaceholder")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.whiteColour)
                                    .multilineTextAlignment(.center)
                                
                                Text("Strings.newSearchPlaceholder")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.grayColour)
                                    .multilineTextAlignment(.center)
                                
                            } else {
                                Image("ic_search_empty_background")
                                    .resizable()
                                    .frame(width: 93, height: 120, alignment: .center)
                                
                                Text("Strings.noSearchData")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.whiteColour)
                                    .multilineTextAlignment(.center)
                                
                                Text("\("Strings.noSearchDataFor") \(viewModel.searchTextField)")
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
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        if viewModel.selectedIndex == 0 {
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
