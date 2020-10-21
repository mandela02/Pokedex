//
//  SearchBarView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct SearchBar: View {
    var placeholder: String = "Search pokemon name."
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .imageScale(.medium)
                .foregroundColor(Color(.systemGray3))
                .padding(3)
            TextField(placeholder, text: $text)
                .font(.system(size: 15))
            if text != "" {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .foregroundColor(Color(.systemGray3))
                    .padding(3)
                    .onTapGesture {
                        withAnimation {
                            self.text = ""
                        }
                    }
            }
        }
        .background(Capsule().fill(Color(.systemGray6)).padding(.all, -10))
        .padding()
    }
}
