//
//  MovesView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import SwiftUI

struct MovesView: View {
    var pokemon: Pokemon
    @StateObject var moveUpdater: MovesUpdater = MovesUpdater()
    var body: some View {
        GeometryReader(content: { geometry in
            let width = geometry.size.width - 100
            let height = width * 0.2

            List {
                Section {
                    ForEach(moveUpdater.moveCellModels) { cell in
                        TappableMoveCell(selectedMove: $moveUpdater.selected, pokemonMove: cell.pokemonMove, move: cell.move)
                            .frame(height: cell.move.name == moveUpdater.selected ? height + 220 : height)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .animation(.spring())
            .onAppear {
                moveUpdater.pokemonMoves = pokemon.moves
            }
        })
    }
}

struct TappableMoveCell: View {
    var type: PokemonType = .bug
    @State var isExtensed = false
    @Binding var selectedMove: String?
    var pokemonMove: PokemonMove
    var move: Move
    
    var body: some View {
        MoveCell(pokemonMove: pokemonMove, move: move, isExtensed: $isExtensed)
            .onTapGesture {
                isExtensed.toggle()
                selectedMove = isExtensed ? move.name : nil
            }
            .onChange(of: selectedMove, perform: { value in
                isExtensed = selectedMove == move.name
            })
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 10)
            .padding(.leading, 10)
    }
}

struct MoveCell: View {
    var pokemonMove: PokemonMove
    var move: Move
    @Binding var isExtensed: Bool
    
    
    var body: some View {
        GeometryReader(content: { geometry in
            let type = PokemonType.type(from: move.type?.name ?? "")
            let width = geometry.size.width
            let height = width * 0.2 + 10
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        Image("ic_pokeball")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(x: height/3)
                            .scaleEffect(1.1)
                            .foregroundColor(type.color.background.opacity(0.5))
                    }
                    VStack() {
                        SkillNameView(move: move, pokemonMove: pokemonMove)
                            .padding(.top, 30)
                        Spacer()
                        SkillPowerView(move: move)
                            .padding(.bottom, 30)
                    }
                }
                .frame(height: height)
                if isExtensed {
                    VStack(spacing: 5) {
                        MachineSubView(move: move)
                            .padding(.leading, 20)
                        TextInformationView(move: move, pokemonMove: pokemonMove)
                            .padding(.all, 5)
                    }
                }
            }
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(type.color.background.opacity(0.5), lineWidth: 5)
            )
            .cornerRadius(25)
        })
    }
}

struct SkillNameView: View {
    var move: Move
    var pokemonMove: PokemonMove
    
    var body: some View {
        HStack(alignment: .firstTextBaseline){
            Text(move.name?.capitalized ?? "")
                .font(Biotif.bold(size: 30).font)
                .foregroundColor(.black)
            Spacer()
            Text("Lvl. \(pokemonMove.versionGroupDetails.first?.levelLearnedAt ?? 0)")
                .font(Biotif.bold(size: 15).font)
                .foregroundColor(Color(.darkGray))
        }
        .padding(.leading, 20)
        .padding(.trailing, 30)
    }
}

struct SkillPowerView: View {
    var move: Move
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            let type = PokemonType.type(from: move.type?.name ?? "")
            TypeBubbleCellView(text: type.rawValue.capitalized,
                               foregroundColor: type.color.text,
                               backgroundColor: type.color.background,
                               font: Biotif.book(size: 12).font)
            Spacer()
            HStack(alignment: .center, spacing: 20) {
                Text("Power: \(move.power ?? 0)")
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(Color(.darkGray))
                Text("PP: \(move.pp ?? 0)")
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(Color(.darkGray))
            }
        }
        .padding(.leading, 50)
        .padding(.trailing, 30)
    }
}

struct TextInformationView: View {
    var move: Move
    var pokemonMove: PokemonMove

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("How to learn: \(pokemonMove.versionGroupDetails.first?.moveLearnMethod.name.capitalized ?? "")")
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(Color(.black))
            
            Text("Appears on a newly-hatched Pokémon, if the father had the same move.")
                .font(Biotif.book(size: 10).font)
                .foregroundColor(Color(.darkGray))
            
            Text(StringHelper.getEnglishText(from: move.effectEntries ?? []))
                .font(Biotif.book(size: 10).font)
                .foregroundColor(Color(.darkGray))
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 8, x: -10, y: 10)
                .padding(.all, 5)
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
    }
}

struct MachineSubView: View {
    var move: Move
    
    var body: some View {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Target")
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(Color(.darkGray))
                    Text("Machine")
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(Color(.darkGray))
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(move.target?.name.capitalized ?? "")
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(Color.black)
                    Text("tm02")
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(.black)
                }
                Spacer()
            }
    }
}
