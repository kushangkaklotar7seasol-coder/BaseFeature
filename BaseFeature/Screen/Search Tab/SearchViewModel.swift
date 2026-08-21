//
//  SearchViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import Foundation
import Combine
import UIKit

class SearchViewModel: ObservableObject {
    @Published var searchTextField: String = ""
    @Published var isLoading = false
    @Published var moviesResponse: MediaCredits?
    @Published var seriesResponse: MediaCredits?
    
    @Published var movies: [MediaItem] = []
    @Published var series: [MediaItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    @Published var selectedSegment: Int = 0
    
    @Published var keyboardHeight: CGFloat = 0
    @Published var isKeyboardVisible: Bool = false
    
//    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchTextField
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] finalValue in
                self?.perform(finalValue)
            }
            .store(in: &cancellables)
        
        let showPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { rect in rect.height }
        
        let hidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        Publishers.Merge(showPublisher, hidePublisher)
            .receive(on: RunLoop.main)
            .sink { [weak self] height in
                self?.keyboardHeight = height
                self?.isKeyboardVisible = height > 0
            }
            .store(in: &cancellables)
    }
    
    func perform(_ text: String) {
        self.moviesResponse = nil
        self.movies = []
        self.seriesResponse = nil
        self.series = []
        
        if self.selectedSegment == 0 {
            self.moviesSearchAPI(text: text.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            self.searchSeriesAPI(text: text.trimmingCharacters(in: .whitespacesAndNewlines))

        }
    }
    
    func manageAPICalls(index: Int){
        
        if index == 0 {
            if movies.isEmpty {
                self.moviesSearchAPI(text: self.searchTextField.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        } else {
            if series.isEmpty {
                self.searchSeriesAPI(text: self.searchTextField.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    
    // MARK: - API Call's -
    func moviesSearchAPI(text: String, isFromPagination: Bool = false) {
        if Utility.isInternetAvailable() {
            self.isLoading = true
            HomeServices.shared.searchMovieAPI(text: text, page: isFromPagination ? (self.moviesResponse?.page ?? 1)+1 : self.moviesResponse?.page ?? 1) { statusCode, response in
                self.isLoading = false
                self.moviesResponse = response
                print(response.page)
                
                for i in response.results {
                    self.movies.append(i)
                }
                
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func searchSeriesAPI(text: String, isFromPagination: Bool = false) {
        if Utility.isInternetAvailable() {
            self.isLoading = true
            HomeServices.shared.searchSeriesAPI(text: text, page: isFromPagination ? (self.seriesResponse?.page ?? 1)+1 : self.seriesResponse?.page ?? 1) { statusCode, response in
                self.isLoading = false
                self.seriesResponse = response
                print(response.page)
                
                for i in response.results {
                    self.series.append(i)
                }
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
}
