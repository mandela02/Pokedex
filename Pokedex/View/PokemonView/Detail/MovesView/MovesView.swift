//
//  MovesView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import SwiftUI

struct MovesView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @StateObject var moveUpdater: MovesUpdater = MovesUpdater()
    var pokemon: Pokemon
    
    var body: some View {
        Group {
            if moveUpdater.isLoadingData {
                LoadingView(background: isDarkMode ? Color.black : Color.white)
            } else {
                MovesContentView(moveUpdater: moveUpdater, pokemon: pokemon)
            }
        }.onAppear {
            moveUpdater.pokemon = pokemon
        }
    }
}
struct MovesContentView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    
    @ObservedObject var moveUpdater: MovesUpdater
    var pokemon: Pokemon
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = geometry.size.width - 80
            let height = width * 0.3
            
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    ForEach((0 ..< moveUpdater.groupedMoveCellModels.count), id:\.self) { index in
                        VStack(spacing: 10) {
                            HStack {
                                Text(moveUpdater.groupedMoveCellModels[index].title.capitalizingFirstLetter())
                                    .font(Biotif.extraBold(size: 25).font)
                                    .foregroundColor(isDarkMode ? .white : .black)
                                Spacer()
                                Image(systemName: "arrowtriangle.right")
                                    .renderingMode(.template)
                                    .foregroundColor(isDarkMode ? .white : .black)
                                    .rotationEffect(.degrees(moveUpdater.groupedMoveCellModels[index].isExpanded ? 90 : 0))
                            }.onTapGesture {
                                withAnimation(.easeInOut) {
                                    moveUpdater.groupedMoveCellModels[index].isExpanded.toggle()
                                }
                            }
                            if moveUpdater.groupedMoveCellModels[index].isExpanded {
                                LazyVStack(alignment: .leading) {
                                    ForEach(moveUpdater.groupedMoveCellModels[index].data) { cell in
                                        let isSelected = cell.move.name == moveUpdater.selected
                                        VStack {
                                            TappableMoveCell(selectedMove: $moveUpdater.selected,
                                                             pokemonMove: cell.pokemonMove,
                                                             move: cell.move,
                                                             smallHeight: height)
                                                .onWillDisappear {
                                                    if isSelected {
                                                        moveUpdater.selected = nil
                                                    }
                                                }
                                            Color.clear.frame(height: 5)
                                        }
                                    }
                                }
                            }
                            Color.clear.frame(height: 5)
                        }
                    }
                }
                Color.clear.frame(height: 100)
            }.frame(alignment: .leading)
            .background(isDarkMode ? Color.black : Color.white)
            .animation(.default)
            .padding()
        })
    }
    
    private func getExtraHeight(of cell: MoveCellModel, width: CGFloat) -> CGFloat {
        let isSelected = cell.move.name == moveUpdater.selected
        var extraHeight: CGFloat = 0
        if isSelected {
            let textSize = StringHelper
                .getStringLength(text: cell.move.effectEntries?.first?.effect ?? "")
            extraHeight = textSize.height + textSize.width/(width - 180) * 10
        }
        return extraHeight + 200
    }
}

struct TappableMoveCell: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    
    @State var isExtensed = false
    
    @Binding var selectedMove: String?
    var pokemonMove: PokemonMove
    var move: Move
    var smallHeight: CGFloat
    
    var body: some View {
        MoveCell(isExtensed: $isExtensed,
                 pokemonMove: pokemonMove,
                 move: move,
                 smallHeight: smallHeight)
            .onTapGesture(count: 1, perform: {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    isExtensed.toggle()
                    selectedMove = isExtensed ? move.name : nil
                }
            }).onChange(of: selectedMove, perform: { value in
                withAnimation(.spring()) {
                    isExtensed = selectedMove == move.name
                }
            })
            .buttonStyle(PlainButtonStyle())
            .disabled(reachabilityUpdater.hasNoInternet)
    }
}

struct MoveCell: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @StateObject var updater = MoveDetailUpdater()
    
    @Binding var isExtensed: Bool
    var pokemonMove: PokemonMove
    var move: Move
    var smallHeight: CGFloat
    
    var body: some View {
        VStack {
            SmallMoveCellView(move: updater.moveCellModel.move,
                              level: updater.moveCellModel.pokemonMove.versionGroupDetails.first?.levelLearnedAt ?? 00,
                              isExtensed: $isExtensed)
                .frame(height: smallHeight)
            if isExtensed {
                VStack(spacing: 5) {
                    MachineSubView(move: updater.moveCellModel.move,
                                   machine: updater.moveCellModel.machine,
                                   target: StringHelper.getEnglishText(from: updater.moveCellModel.target.descriptions))
                        .padding(.leading, 20)
                    TextInformationView(move: updater.moveCellModel.move,
                                        pokemonMove: updater.moveCellModel.pokemonMove,
                                        learnMethod: StringHelper.getEnglishText(from: updater.moveCellModel.learnMethod.descriptions))
                        .padding(.all, 5)
                }
            }
        }
        .background(isDarkMode ? Color.black : Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(PokemonType.type(from: updater.move?.type?.name ?? "").color.background.opacity(0.5), lineWidth: 5)
        )
        .cornerRadius(25)
        .onAppear {
            updater.pokemonMove = pokemonMove
            updater.move = move
        }.onWillDisappear {
            updater.pokemonMove = nil
            updater.move = nil
        }
    }
}

struct SkillNameView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    
    var move: Move
    var level: Int?
    
    var body: some View {
        HStack(alignment: .lastTextBaseline){
            Text(move.name?.capitalizingFirstLetter() ?? "")
                .font(Biotif.bold(size: 25).font)
                .foregroundColor(isDarkMode ? .white : .black)
            Spacer()
            if let level = level {
                Text("Lvl. \(level)")
                    .font(Biotif.bold(size: 15).font)
                    .foregroundColor(isDarkMode ? Color.white : Color(.darkGray))
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 30)
    }
}

struct SkillPowerView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    
    var move: Move
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            let type = PokemonType.type(from: move.type?.name ?? "")
            TypeBubbleCellView(text: type.rawValue.capitalizingFirstLetter(),
                               foregroundColor: .white,
                               backgroundColor: type.color.background,
                               font: Biotif.book(size: 12).font)
            Spacer()
            HStack(alignment: .center, spacing: 20) {
                Text("Power: \(move.power ?? 0)")
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(isDarkMode ? Color.white : Color(.darkGray))
                Text("PP: \(move.pp ?? 0)")
                    .font(Biotif.semiBold(size: 12).font)
                    .foregroundColor(isDarkMode ? Color.white : Color(.darkGray))
            }
        }
        .padding(.leading, 50)
        .padding(.trailing, 30)
    }
}

struct TextInformationView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    
    var move: Move
    var pokemonMove: PokemonMove
    var learnMethod: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("How to learn: \(pokemonMove.versionGroupDetails.first?.moveLearnMethod.name.capitalizingFirstLetter() ?? "")")
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            Text(learnMethod)
                .font(Biotif.book(size: 10).font)
                .foregroundColor(isDarkMode ? .white : Color(.darkGray))
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            Text(StringHelper.getEnglishText(from: move.effectEntries ?? []))
                .font(.system(size: 10))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                .foregroundColor(isDarkMode ? .white : Color(.darkGray))
                .padding()
                .background(isDarkMode ? Color.black : Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3)
                .padding(.all, 5)
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
    }
}

struct MachineSubView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    
    var move: Move
    var machine: Machine
    var target: String
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Target")
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(isDarkMode ? .white : Color(.darkGray))
                        .frame(width: 50, alignment: .leading)
                    Text(target.capitalizingFirstLetter())
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(isDarkMode ? Color.white : Color.black)
                }
                HStack {
                    Text("Machine")
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(isDarkMode ? .white : Color(.darkGray))
                        .isRemove(machine.item.name.isEmpty)
                        .frame(width: 50, alignment: .leading)
                    Text(machine.item.name.capitalizingFirstLetter())
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(isDarkMode ? .white : .black)
                        .isRemove(machine.item.name.isEmpty)
                }
            }
            Spacer()
        }
    }
}

struct SmallMoveCellView: View {
    var move: Move
    var level: Int?
    @Binding var isExtensed: Bool
    
    var body: some View {
        ZStack {
            GeometryReader { reader in
                HStack {
                    Spacer()
                    Image("ic_pokeball")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(x: 20)
                        .scaleEffect(isExtensed ? 1.5 : 1.1)
                        .foregroundColor(PokemonType.type(from: move.type?.name ?? "").color.background.opacity(0.5))
                        .frame(width: reader.size.width * 0.3)
                }
            }
            VStack(spacing: 10) {
                SkillNameView(move: move, level: level)
                    .padding(.top, 30)
                SkillPowerView(move: move)
                    .padding(.bottom, 30)
            }
        }
    }
}
