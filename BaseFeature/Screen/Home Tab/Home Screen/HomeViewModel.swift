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
                                                                   name: "Goal Tracker",
                                                                   image: "ic_goal",
                                                                   info: "Set goals, track progress and achieve more"),
                                                   
                                                   QuichToolsModel(id: 1,
                                                                   name: "Image to PDF",
                                                                   image: "ic_pdf",
                                                                   info: "Convert your images to PDF in one tap."),
                                                   
                                                   QuichToolsModel(id: 2,
                                                                   name: "Notes",
                                                                   image: "ic_notes",
                                                                   info: "Write, organize and keep your notes safe."),
                                                   
                                                   QuichToolsModel(id: 3,
                                                                   name: "Percentage Calculator",
                                                                   image: "ic_precentage",
                                                                   info: "Calculate percentages easily and instantly.")]
    
    init(){
    }
    
    func onQuickTool(_ item: QuichToolsModel){
        switch item.id {
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
