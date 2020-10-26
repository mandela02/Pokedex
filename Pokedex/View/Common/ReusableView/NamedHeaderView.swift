//
//  NamedHeaderView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/26/20.
//

import SwiftUI

struct NamedHeaderView: View {
    var name: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(name.capitalized)
                .font(Biotif.extraBold(size: 20).font)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.top, 50)
        .padding(.bottom, 20)
        .background(GradienView(atTop: true))
    }
}
