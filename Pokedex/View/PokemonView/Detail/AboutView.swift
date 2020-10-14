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
    case non
    
    var color: Color {
        switch self {
        case .female: return .pink
        case .male: return .blue
        case .non: return .purple
        }
    }
}

struct AboutView: View {
    var pokemon: Pokemon
    @ObservedObject var updater: SpeciesUpdater
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            AboutContentView(pokemon: pokemon, updater: updater)
            Color.clear.frame(height: 150, alignment: .center)
        }.background(Color.clear)
    }
}

struct AboutContentView: View {
    var id = UUID()
    var pokemon: Pokemon
    @ObservedObject var updater: SpeciesUpdater
    
    @State var description: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(description)
                .font(.custom("Biotif-Medium", size: 15))
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                .onReceive(updater.$description) { text in
                    description = text
                }
            
            SizeView(height: pokemon.height, weight: pokemon.weight)
                .background(HexColor.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 8, x: -10, y: 10)
                .padding()
                .padding(.bottom, 20)
            
            Text("Breeding")
                .font(.custom("Biotif-SemiBold", size: 20))
                .foregroundColor(.black)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            BreedingView(rate: updater.species.genderRate,
                         group: updater.species.eggGroup.first?.name ?? "",
                         habitat: updater.species.habitat?.name ?? "")
                .padding(.leading, 20)
                .padding(.top, 10)
            Spacer()
        }.background(Color.clear)
    }
}

struct BreedingView: View {
    var rate: Int
    var group: String
    var habitat: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Gender")
                    .font(.custom("Biotif-Bold", size: 12))
                    .foregroundColor(.gray)
                Text("Egg Groups")
                    .font(.custom("Biotif-Bold", size: 12))
                    .foregroundColor(.gray)
                Text("Habitat")
                    .font(.custom("Biotif-Bold", size: 12))
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 20) {
                    if rate > 0 {
                        GenderView(gender: .male, rate: rate)
                        GenderView(gender: .female, rate: rate)
                    } else {
                        GenderView(gender: .non, rate: rate)
                    }
                }
                Text(group.capitalizingFirstLetter())
                    .font(.custom("Biotif-Bold", size: 12))
                    .foregroundColor(.gray)
                Text(habitat.capitalizingFirstLetter())
                    .font(.custom("Biotif-Bold", size: 12))
                    .foregroundColor(.gray)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct GenderView: View {
    var gender: Gender
    var rate: Int
    
    var body: some View {
        HStack(spacing: 10) {
            Image(gender.rawValue)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, alignment: .center)
                .foregroundColor(gender.color)
            Text(StringHelper.getGenderRateString(gender: gender, rate: rate))
                .font(.custom("Biotif-SemiBold", size: 12))
                .foregroundColor(.gray)
        }
    }
}

struct SizeView: View {
    var height: Int
    var weight: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Height")
                    .font(.custom("Biotif-Bold", size: 12))
                    .foregroundColor(.gray)
                Text(StringHelper.heightString(from: height))
                    .font(.custom("Biotif-SemiBold", size: 12))
                    .foregroundColor(.gray)
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight")
                    .font(.custom("Biotif-Bold", size: 12))
                    .foregroundColor(.gray)
                Text(StringHelper.weightString(from: weight))
                    .font(.custom("Biotif-SemiBold", size: 12))
                    .foregroundColor(.gray)                
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
