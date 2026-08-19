//
//  HomeViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 11/08/26.
//

import Foundation
import Combine
import Photos
import MediaPlayer

class HomeViewModel: ObservableObject {
    @Published var quickTool: [QuichToolsModel] = [QuichToolsModel(id: 0,
                                                                   name: "GOAL_TRACKER",
                                                                   image: "ic_goal",
                                                                   info: "GOAL_TRACKER_INFO"),
                                                   
                                                   QuichToolsModel(id: 1,
                                                                   name: "IMAGE_TO_PDF",
                                                                   image: "ic_pdf",
                                                                   info: "IMAGE_TO_PDF_INFO"),
                                                   
                                                   QuichToolsModel(id: 2,
                                                                   name: "NOTES",
                                                                   image: "ic_notes",
                                                                   info: "NOTES_INFO"),
                                                   
                                                   QuichToolsModel(id: 3,
                                                                   name: "PERCENTAGE_CALCULATOR",
                                                                   image: "ic_precentage",
                                                                   info: "PERCENTAGE_CALCULATOR_INFO")]
    
    
    func onQuickTool(_ item: QuichToolsModel){
        switch item.id {
        case 0:
            Router.shared.push(.myGoal)
        case 1:
            Router.shared.push(.imageToPDF)
        case 2:
            Router.shared.push(.notesScreen)
        case 3:
            Router.shared.push(.calculator)
        default:
            print("No nvaigation find")
        }
    }
}
