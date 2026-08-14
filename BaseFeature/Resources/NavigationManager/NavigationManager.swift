//
//  NavigationManager.swift
//  Movie Box
//
//  Created by Kushang kaklotar on 24/07/26.
//

import Foundation
import Combine
import SwiftUI

@ViewBuilder
func destination(for route: Route) -> some View {
    switch route {
    case .splash:
        Splash()
    case .language(let isShowBackButton):
        LanguageScreen(viewModel: LanguageViewModel(isShowBack: isShowBackButton))
    case .intro:
        IntoScreen()
    case .tab:
        TabBar()
    case .storageOverview:
        StorageOverviewScreen()
    case .movieDetail(let movieId, let isMovie):
        MovieDetailScreen(viewModel: MovieDetailViewModel(movieId: movieId, isMovie: isMovie))
    case .castDetail(let celebrityId):
        PersonDetailScreen(viewModel: PersonDetailViewModel(celebrityId: celebrityId))
    case .movieListing(let mediaBunch):
        MovieListingScreen(viewModel: MovieListingViewModel(media: mediaBunch))
    case .personListing(personDetail: let person):
        PersonListingScreen(viewModel: PersonListingViewModel(person: person))
    case .castCrewListing(cast: let cast, header: let header):
        CastCrewListingScreen(cast: cast, header: header)
    case .videoListing(videos: let videos,header: let header):
        VideoListingScreen(videos: videos, header: header)
    case .favouriteScreen:
        FavouriteScreen()
    }
}

enum Route: Hashable {
    case splash
    case language(isShowBackButton: Bool)
    case intro
    case tab
    
    case storageOverview
    case movieDetail(movieId: Int, isMovie: Bool)
    case castDetail(celebrityId: Int)
    case movieListing(movieBunch: MediaBunch?)
    case personListing(personDetail: CelebrityResponse?)
    case castCrewListing(cast: [CastMember], header: String)
    case videoListing(videos: [Video], header: String)
    case favouriteScreen
}

final class Router: ObservableObject {
    static let shared = Router()
    @Published var path = NavigationPath()
    @Published var rootRoute: Route = .splash
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func updateRoot(_ route: Route) {
        path.removeLast(path.count)
        rootRoute = route
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
