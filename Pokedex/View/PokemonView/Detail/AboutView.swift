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
    
    @State var showAbilityDetail: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            GeneralDetailView(pokemon: pokemon,
                              species: updater.species,
                              isExtened: $showAbilityDetail)
                .frame(height: 120, alignment: .center)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            
            if showAbilityDetail {
                AbilityDetailView()
                    .padding()
            }
            
            SizeView(height: pokemon.height, weight: pokemon.weight)
                .background(HexColor.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 8, x: -10, y: 10)
                .padding()
                .padding(.bottom, 20)
            
            Text("Breeding")
                .font(Biotif.extraBold(size: 20).font)
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
                Text(group.capitalized)
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(.black)
                Text(habitat.capitalized)
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(.black)
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
                .frame(width: 10, alignment: .center)
                .foregroundColor(gender.color)
            Text(StringHelper.getGenderRateString(gender: gender, rate: rate))
                .font(Biotif.semiBold(size: 12).font)
                .foregroundColor(.black)
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
                    .font(Biotif.bold(size: 12).font)
                    .foregroundColor(.gray)
                Text(StringHelper.heightString(from: height))
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(.black)
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight")
                    .font(Biotif.bold(size: 12).font)
                    .foregroundColor(.gray)
                Text(StringHelper.weightString(from: weight))
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(.black)
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

struct GeneralDetailView: View {
    var pokemon: Pokemon
    var species: Species
    @Binding var isExtened: Bool

    @State var showGif = false

    var body: some View {
        GeometryReader(content: { geometry in
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 20) {
                    SpeciesNameView(species: species)
                    AbilitesView(pokemon: pokemon, isExtened: $isExtened)
                        .frame(width: abs(geometry.size.width - 100))
                }

                if showGif {
                    GIFView(gifName: pokemon.sprites.versions?.generationV?.blackWhite?.animated?.front ?? "")
                        .frame(width: 80, height: 80, alignment: .center)
                        .padding(.trailing, 10)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.linear) {
                        showGif = true
                    }
                }
            }
        })
    }
}

struct AbilitesView: View {
    var pokemon: Pokemon
    @Binding var isExtened: Bool
    @State var selectedString: String?

    var body: some View {
        VStack(spacing: 10) {
            Text("Abilities")
                .font(Biotif.extraBold(size: 20).font)
                .foregroundColor(.black)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            HStack(alignment: .center, spacing: 30) {
                ForEach(pokemon.abilities.map({$0.ability.name.capitalized}), content: { text in
                    TypeBubbleCellView(text: text,
                                       foregroundColor: text == selectedString ? .white : .gray,
                                       backgroundColor: text == selectedString ? .gray : .white,
                                       font: Biotif.semiBold(size: 15).font)
                        .onTapGesture {
                            if text == selectedString {
                                selectedString = nil
                                withAnimation(.spring()) {
                                    isExtened = false
                                }
                            } else {
                                selectedString = text
                                withAnimation(.spring()) {
                                    isExtened = false
                                    isExtened = true
                                }
                            }
                        }
                })
                Spacer()
            }
            .padding(.leading, 40)
            .transition(.opacity)
            .animation(.easeIn)
        }
    }
}

struct SpeciesNameView: View {
    var species: Species

    var body: some View {
        HStack {
            Text("Species")
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(.gray)
                .frame(width: 50, alignment: .leading)
            Text(StringHelper.getEnglishText(from: species.genera))
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(.black)
                .padding(.leading, 5)
            Spacer()
        }
        .frame(height: 30, alignment: .center)
    }
}

struct AbilityDetailView: View {
    var height: CGFloat = 100
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Image("ic_pokeball")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: height/3)
                    .scaleEffect(1.1)
            }
            
            VStack(spacing: 5) {
                    Text("Species")
                        .font(Biotif.bold(size: 15).font)
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity,
                               alignment: .leading)

                    Text("Description")
                        .font(Biotif.regular(size: 12).font)
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               alignment: .leading)
            }
            .padding(.leading, 20)
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black, lineWidth: 5)
        )
        .cornerRadius(25)
        .frame(height: height, alignment: .center)
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AbilityDetailView()
    }
}
