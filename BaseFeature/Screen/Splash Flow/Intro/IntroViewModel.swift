//
//  IntroViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import Foundation
import Combine

class IntroViewModel: ObservableObject {
    @Published var information: [OnBordingInfo] = [OnBordingInfo(id: 0,
                                                                 image: "img_intro_1",
                                                                 name: "Convert Images",
                                                                 name2: "To PDF",
                                                                 info: "Turn your images into high-quality PDFs in seconds. Fast, secure, and easy to share."),
                                                   OnBordingInfo(id: 1,
                                                                 image: "img_intro_2",
                                                                 name: "Manage Your",
                                                                 name2: "Storage",
                                                                 info: "Monitor and clean your device storage to keep more of what matters"),
                                                   OnBordingInfo(id: 2,
                                                                 image: "img_intro_3",
                                                                 name: "Reach Every",
                                                                 name2: "Goal",
                                                                 info: "Track your habits, tasks, and milestones. Stay focused and achieve more."),
    
                                                   OnBordingInfo(id: 3,
                                                                 image: "img_intro_4",
                                                                 name: "Discover",
                                                                 name2: " Movies & Shows",
                                                                 info: "Note :- Discover trailers and streaming details before watching your favorites.")]
}
