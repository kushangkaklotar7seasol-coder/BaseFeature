//
//  NavigationManager.swift
//  Movie Box
//
//  Created by Kushang kaklotar on 24/07/26.
//

import Foundation
import Combine
import SwiftUI
import Photos

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
    case .notesScreen:
        NotesScreen()
    case .addNote(let note):
        AddNoteScreen(viewModel: AddNoteViewModel(oldNote: note))
    case .notesDisplay(let index, let allNote):
        DisplayNoteScreen(viewModel: DisplayNotesViewModel(notesIndex: index, allNotes: allNote))
    case .calculator:
        CalculatorScreen()
    case .imageToPDF:
        ImageToPDFScreen()
    case .selectImage:
        SelectImageScreen()
    case .arrangeImage(let images):
        ArrangePageScreen(viewModel: ArrangePageViewModel(selectedAssets: images))
    case .rotateImage(images: let images):
        RotateImage(viewModel: RotateViewModel(selectedAssets: images))
    case .pdfCreated(url: let url, images: let images):
        PDFCreatedScreen(generatedPDFURL: url, selectedAssets: images)
    case .myGoal:
        MyGoalScreen()
    case .newGoal:
        NewGoalScreen()
    case .goalList(let displayType):
        GoalListScreen(viewModel: GoalListViewModel(type: displayType))
    case .goalDetail(goal: let goal):
        GoalDetailScreen(viewModel: GoalDetailViewModel(goal: goal))
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
    case notesScreen
    case addNote(note: Notes?)
    case notesDisplay(index: Int, allNote: [Notes])
    case calculator
    case imageToPDF
    case selectImage
    case arrangeImage(images: [PHAsset])
    case rotateImage(images: [PHAsset])
    case pdfCreated(url: URL?, images: [PHAsset])
    case myGoal
    case newGoal
    case goalList(displayType: Int)
    case goalDetail(goal: Goal)
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

var isSwipeBackenable = true

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isSwipeBackenable {
            return viewControllers.count > 1
        }
        
        return false
    }
}
