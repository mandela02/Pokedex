//
//  LocationPokemonGridCellView.swift
//  Pokedex
//
//  Created by TriBQ on 20/11/2020.
//

import SwiftUI

struct LocationPokemonGridCellView: View {
    var size: CGSize = CGSize(width: 300, height: 200)
    var fontSize: CGFloat = 12
    var body: some View {
        ZStack {
            Color.red
            HStack {
                Spacer()
                Image("ic_pokeball")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: size.height/3)
                    .foregroundColor(Color.white.opacity(0.5))
            }
            
            HStack {
                Image("pokeball")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width/2,
                           height: size.height,
                           alignment: .bottomTrailing)
            }.frame(width: size.width, height: size.height, alignment: .bottomTrailing)
            
            VStack(alignment: .leading, spacing: 0, content: {
                HStack {
                    Text("Charmander")
                        .font(Biotif.extraBold(size: 25).font)
                        .foregroundColor(.white)
                        .frame(alignment: .topLeading)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("#005")
                        .font(Biotif.extraBold(size: 15).font)
                        .foregroundColor(.white)
                        .frame(alignment: .topLeading)
                        .lineLimit(1)
                }.padding(.bottom, 10)
                
                ForEach(["Fire"]) { type in
                    TypeBubbleCellView(text: type,
                                       foregroundColor: Color.white,
                                       backgroundColor: Color.white.opacity(0.3),
                                       font: Biotif.semiBold(size: 10).font)
                        .padding(.bottom, 15)
                        .padding(.leading, 15)
                }
                
                EncounterChangeView()
                
                MinMaxLevelView()
                
                EncounterView(size: size)
            }).frame(width: size.width, height: size.height, alignment: .topLeading)
            .padding(.leading, 25)
            .padding(.trailing, 25)
            .padding(.top, 25)
            
        }
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.red.opacity(0.5),
                        lineWidth: 10)
        )
        .cornerRadius(25)
        .frame(width: size.width, height: size.height)
    }
}

struct LocationPokemonGridCellView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPokemonGridCellView()
    }
}

struct EncounterChangeView: View {
    var fontSize: CGFloat = 12

    var body: some View {
        HStack {
            Text("Encounter chance: ")
                .foregroundColor(.white)
                .font(Biotif.medium(size: fontSize).font)
            Text("20%")
                .foregroundColor(.white)
                .font(Biotif.bold(size: fontSize).font)
        }.shadow(color: .red, radius: 1)
    }
}

struct MinMaxLevelView: View {
    var fontSize: CGFloat = 12

    var body: some View {
        HStack(spacing: 5) {
            HStack {
                Text("Min Level: ")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: fontSize).font)
                Text("5")
                    .foregroundColor(.white)
                    .font(Biotif.bold(size: fontSize).font)
                Spacer()
            }.shadow(color: .red, radius: 1)
            
            HStack {
                Text("Max Level: ")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: fontSize).font)
                Text("20")
                    .foregroundColor(.white)
                    .font(Biotif.bold(size: fontSize).font)
                Spacer()
            }.shadow(color: .red, radius: 1)
        }.padding(.top, 10)
    }
}

struct EncounterView: View {
    var fontSize: CGFloat = 12
    var size: CGSize
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Method: ")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: 15).font)
                Text("Surf")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: 15).font)
            }
            .frame(width: size.width, alignment: .leading)
            
            Text("Use surf to catch this pokemon")
                .foregroundColor(Color.white.opacity(0.8))
                .font(Biotif.medium(size: fontSize).font)
                .padding(.leading, 10)
                .frame(width: size.width, alignment: .leading)
                .shadow(color: .red, radius: 1)
        }
        .padding(.top, 10)
    }
}
