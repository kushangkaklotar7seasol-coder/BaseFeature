//
//  Color+Extension.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == LinearGradient {
    static var leftTorightGradient: LinearGradient {
        LinearGradient(colors: [.blueColour, .purpleColour], startPoint: .leading, endPoint: .trailing)
    }
    
    static var topTobottomGradient: LinearGradient {
        LinearGradient(colors: [.blueColour, .purpleColour], startPoint: .top, endPoint: .bottom)
    }
    
    static var grayGradient: LinearGradient {
        LinearGradient(colors: [.grayColour, .grayColour], startPoint: .top, endPoint: .bottom)
    }
    
    static var strongPrimeGradient: LinearGradient {
        LinearGradient(colors: [.skyBlueColour, .blueColour, .lightPinkColour], startPoint: .leading, endPoint: .trailing)
    }
    
    static var clearGradient: LinearGradient {
        LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom)
    }
}
