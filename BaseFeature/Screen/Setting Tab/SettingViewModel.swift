//
//  SettingViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import Foundation
import Combine
import UIKit

class SettingViewModel: ObservableObject {
    var settingItem: [PersonalDetail] = [PersonalDetail(id: 0, name: "LANGUAGE", value: "ic_language"),
                                         PersonalDetail(id: 1, name: "RATE_US", value: "ic_rate_app"),
                                         PersonalDetail(id: 2, name: "SHARE_APP", value: "ic_share"),
                                         PersonalDetail(id: 3, name: "PRIVECY_POLICY", value: "ic_privacypolicy"),
                                         PersonalDetail(id: 4, name: "TERMS_USE", value: "ic_terms")]
    
    
    func onSelect(_ id: Int) {
        switch id {
        case 0:
            Router.shared.push(.language(isShowBackButton: true))
        case 1:
            self.rateApp()
        case 2:
            self.shareApp()
        case 3:
            self.openURL(AppInfo.privacyPolicy)
        case 4:
            self.openURL(AppInfo.termsOfUse)
        default: break;
        }
    }
    
    // MARK: - Actions
    func shareApp() {
        guard let url = URL(string: AppInfo.shareApp) else { return }
        
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else {
            return
        }
        
        // Top-most controller find karo
        var topController = root
        while let presented = topController.presentedViewController {
            topController = presented
        }
        
        // iPad mate popover setup (aa compulsory che)
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = topController.view
            popover.sourceRect = CGRect(
                x: topController.view.bounds.midX,
                y: topController.view.bounds.midY,
                width: 0,
                height: 0
            )
            popover.permittedArrowDirections = []
        }
        
        topController.present(activityVC, animated: true)
    }
    
    func rateApp() {
        guard let url = URL(string: AppInfo.rateApp) else { return }
        UIApplication.shared.open(url)
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
