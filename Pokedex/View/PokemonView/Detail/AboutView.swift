//
//  AboutView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/8/20.
//

import SwiftUI

enum Gender: String {
    case male
    case female
}

struct AboutView: View, Identifiable {
    var id = UUID()
    
    var pokemon: Pokemon
    
    @ObservedObject var updater: SpeciesUpdater = SpeciesUpdater(url: "")

    init(of pokemon: Pokemon) {
        self.pokemon = pokemon
        updater = SpeciesUpdater(url: self.pokemon.species.url)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            CustomText(text: updater.description, size: 15, weight: .medium, textColor: .black)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            
            SizeView(height: pokemon.height, weight: pokemon.weight)
                .background(HexColor.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 8, x: -10, y: 10)
                .padding()
                .padding(.bottom, 20)
            
            CustomText(text: "Breeding", size: 20)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            BreedingView()
                .padding(.leading, 20)
                .padding(.top, 10)
            Spacer()
        }.background(Color.clear)
    }
}

struct BreedingView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            VStack(alignment: .leading, spacing: 10) {
                CustomText(text: "Gender", size: 12, weight: .bold, textColor: .gray)
                CustomText(text: "Egg Groups", size: 12, weight: .bold, textColor: .gray)
                CustomText(text: "Egg Cycle", size: 12, weight: .bold, textColor: .gray)
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 20) {
                    GenderView(gender: .male)
                    GenderView(gender: .female)
                }
                CustomText(text: "Monster", size: 12, weight: .bold, textColor: .gray)
                CustomText(text: "Grass", size: 12, weight: .bold, textColor: .gray)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct GenderView: View {
    var gender: Gender
    
    var body: some View {
        HStack(spacing: 10) {
            Image(uiImage: UIImage(named: gender.rawValue)!.withRenderingMode(.alwaysTemplate))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, alignment: .center)
                .foregroundColor(gender == .male ? .blue : .pink)
            CustomText(text: "20%", size: 12)
        }
    }
}

struct SizeView: View {
    var height: Int
    var weight: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                CustomText(text: "Height", size: 12, weight: .bold, textColor: .gray)
                CustomText(text: StringHelper.heightString(from: height), size: 10, weight: .semibold)
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 4) {
                CustomText(text: "Weight", size: 12, weight: .bold, textColor: .gray)
                CustomText(text: StringHelper.weightString(from: weight), size: 10, weight: .semibold)
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }.padding()
    }
}

struct CustomText: View {
    var text: String = ""
    var size: CGFloat = 0.0
    var weight: Font.Weight = .bold
    var background: Color = .clear
    var textColor: Color = .black
    
    var body: some View {
        Text(text)
            .font(.system(size: size))
            .fontWeight(weight)
            .foregroundColor(textColor)
            .background(background)
    }
}
