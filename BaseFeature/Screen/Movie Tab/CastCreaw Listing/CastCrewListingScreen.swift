//
//  CastCrewListingScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import SwiftUI

struct CastCrewListingScreen: View {
    var cast: [CastMember] = []
    var header: String = ""
    
    var columns: [GridItem] {
        let count = Device.isiPadPortrait ? 5 : Device.isiPadLandscape ? 6 : 3
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
    }
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: header)
                    .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(Array(cast.indices), id: \.self) { index in
                                let person = cast[index]
                                DefaultDesign.PersonPoster(id: person.id, url: person.profilePath ?? "", name: person.name)
                            }
                        }
                        .padding(.horizontal)
                }
            }
        }
        .defaultPage()

    }
}

#Preview {
    CastCrewListingScreen()
}
