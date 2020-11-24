//
//  SpeciesDetailView.swift
//  Pokedex
//
//  Created by TriBQ on 19/10/2020.
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

struct BreedingView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var rate: Int
    var group: String
    var habitat: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Gender")
                    .font(Biotif.bold(size: 12).font)
                    .foregroundColor(.gray)
                Text("Egg Groups")
                    .font(Biotif.bold(size: 12).font)
                    .foregroundColor(.gray)
                Text("Habitat")
                    .font(Biotif.bold(size: 12).font)
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 20) {
                    if rate > 0 {
                        GenderView(gender: .male, rate: rate)
                        GenderView(gender: .female, rate: rate)
                    } else {
                        GenderView(gender: .non, rate: rate)
                    }
                }
                Text(group.capitalizingFirstLetter())
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(isDarkMode ? .white : .black)
                Text(habitat.capitalizingFirstLetter())
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(isDarkMode ? .white : .black)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct GenderView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var gender: Gender
    var rate: Int
    
    var body: some View {
        HStack(spacing: 10) {
            Image(gender.rawValue)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 10, alignment: .center)
                .foregroundColor(gender.color)
            Text(StringHelper.getGenderRateString(gender: gender, rate: rate))
                .font(Biotif.semiBold(size: 12).font)
                .foregroundColor(isDarkMode ? .white : .black)
        }
    }
}

struct SizeView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var height: Int
    var weight: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Height")
                    .font(Biotif.bold(size: 12).font)
                    .foregroundColor(.gray)
                Text(StringHelper.heightString(from: height))
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(isDarkMode ? .white : .black)
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight")
                    .font(Biotif.bold(size: 12).font)
                    .foregroundColor(.gray)
                Text(StringHelper.weightString(from: weight))
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(isDarkMode ? .white : .black)
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }.padding()
    }
}

struct SpeciesNameView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var species: Species

    var body: some View {
        HStack {
            Text("Species")
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(.gray)
                .frame(width: 50, alignment: .leading)
            Text(StringHelper.getEnglishText(from: species.genera ?? []))
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding(.leading, 5)
        }
    }
}


struct DescriptionView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var species: Species
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Description")
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(.gray)
                .frame(alignment: .leading)
            Text(StringHelper.getEnglishText(from: species.flavorTextEntries ?? []))
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding(.leading, 10)
        }
    }
}
