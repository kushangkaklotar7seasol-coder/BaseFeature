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
                                                                 name: "PAGE1_TITLE",
                                                                 name2: "PAGE1_LIGHT_TITLE",
                                                                 info: "PAGE1_INFO"),
                                                   
                                                   OnBordingInfo(id: 1,
                                                                 image: "img_intro_2",
                                                                 name: "PAGE2_TITLE",
                                                                 name2: "PAGE2_LIGHT_TITLE",
                                                                 info: "PAGE2_INFO"),
                                                   
                                                   OnBordingInfo(id: 2,
                                                                 image: "img_intro_3",
                                                                 name: "PAGE3_TITLE",
                                                                 name2: "PAGE3_LIGHT_TITLE",
                                                                 info: "PAGE3_INFO"),
                                                   
                                                   OnBordingInfo(id: 3,
                                                                 image: "img_intro_4",
                                                                 name: "PAGE4_TITLE",
                                                                 name2: "PAGE4_LIGHT_TITLE",
                                                                 info: "PAGE4_INFO")]
}
