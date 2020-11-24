//
//  NamedHeaderView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/26/20.
//

import SwiftUI

struct NamedHeaderView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var name: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(name.capitalizingFirstLetter())
                .font(Biotif.extraBold(size: 20).font)
                .foregroundColor(isDarkMode ? .white : .black)
            Spacer()
        }
        .padding(.top, 50)
        .padding(.bottom, 20)
        .background(GradienView(atTop: true))
    }
}
