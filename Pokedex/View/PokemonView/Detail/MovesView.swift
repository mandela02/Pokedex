//
//  MovesView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import SwiftUI

struct MovesView: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    @ObservedObject var moveUpdater: MovesUpdater
    
    init(pokemon: Pokemon) {
        moveUpdater = MovesUpdater(of: pokemon)
    }
    
    var body: some View {
        ZStack {
            GeometryReader(content: { geometry in
                let width = geometry.size.width - 80
                let height = width * 0.2
                
                List {
                    ForEach(moveUpdater.groupedMoveCellModels) { section in
                        Section(header: Text(section.name.capitalizingFirstLetter()).font(Biotif.extraBold(size: 25).font)) {
                            ForEach(section.cells) { cell in
                                let isSelected = cell.move.name == moveUpdater.selected
                                VStack {
                                    TappableMoveCell(selectedMove: $moveUpdater.selected,
                                                     moveCellModel: cell)
                                        .frame(height: isSelected ? height + getExtraHeight(of: cell, width: width) : height)
                                        .onDisappear {
                                            if isSelected {
                                                moveUpdater.selected = nil
                                            }
                                        }
                                    Color.clear.frame(height: 5)
                                }
                            }
                        }
                    }
                    Color.clear.frame(height: UIScreen.main.bounds.height * 0.4)
                }
                .listStyle(SidebarListStyle())
                .animation(.default)
            })
        }
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
    var moveCellModel: MoveCellModel
    var body: some View {
        Button {
            isExtensed.toggle()
            selectedMove = isExtensed ? moveCellModel.move.name : nil
        } label: {
            MoveCell(moveCellModel: moveCellModel, isExtensed: $isExtensed)
        }
        .onChange(of: selectedMove, perform: { value in
            isExtensed = selectedMove == moveCellModel.move.name
        })
        .buttonStyle(PlainButtonStyle())
        .disabled(reachabilityUpdater.hasNoInternet)
    }
}

struct MoveCell: View {
    var moveCellModel: MoveCellModel
    @Binding var isExtensed: Bool
    var body: some View {
        GeometryReader(content: { geometry in
            let type = PokemonType.type(from: moveCellModel.move.type?.name ?? "")
            let width = geometry.size.width
            let height = width * 0.2 + 10
            VStack {
                SmallMoveCellView(height: height,
                                  move: moveCellModel.move,
                                  level: moveCellModel.pokemonMove.versionGroupDetails.first?.levelLearnedAt ?? 00,
                                  isExtensed: $isExtensed)
                if isExtensed {
                    VStack(spacing: 5) {
                        MachineSubView(move: moveCellModel.move, machine: moveCellModel.machine,
                                       target: StringHelper.getEnglishText(from: moveCellModel.target.descriptions))
                            .padding(.leading, 20)
                        TextInformationView(move: moveCellModel.move,
                                            pokemonMove: moveCellModel.pokemonMove,
                                            learnMethod: StringHelper.getEnglishText(from: moveCellModel.learnMethod.descriptions))
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
    var level: Int?
    
    var body: some View {
        HStack(alignment: .lastTextBaseline){
            Text(move.name?.capitalizingFirstLetter() ?? "")
                .font(Biotif.bold(size: 25).font)
                .foregroundColor(.black)
            Spacer()
            if let level = level {
                Text("Lvl. \(level)")
                    .font(Biotif.bold(size: 15).font)
                    .foregroundColor(Color(.darkGray))
            }
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
            TypeBubbleCellView(text: type.rawValue.capitalizingFirstLetter(),
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
    var learnMethod: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("How to learn: \(pokemonMove.versionGroupDetails.first?.moveLearnMethod.name.capitalizingFirstLetter() ?? "")")
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(Color(.black))
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            Text(learnMethod)
                .font(Biotif.book(size: 10).font)
                .foregroundColor(Color(.darkGray))
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            Text(StringHelper.getEnglishText(from: move.effectEntries ?? []))
                .font(Biotif.book(size: 10).font)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment: .topLeading)
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
    var machine: Machine
    var target: String
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Target")
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(Color(.darkGray))
                        .frame(width: 50, alignment: .leading)
                    Text(target.capitalizingFirstLetter())
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(Color.black)
                }
                HStack {
                    Text("Machine")
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(Color(.darkGray))
                        .isRemove(machine.item.name.isEmpty)
                        .frame(width: 50, alignment: .leading)
                    Text(machine.item.name.capitalizingFirstLetter())
                        .font(Biotif.medium(size: 10).font)
                        .foregroundColor(.black)
                        .isRemove(machine.item.name.isEmpty)
                }
            }
            Spacer()
        }
    }
}

struct SmallMoveCellView: View {
    var height: CGFloat
    var move: Move
    var level: Int?
    @Binding var isExtensed: Bool
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Image("ic_pokeball")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: height/3)
                    .scaleEffect(isExtensed ? 1.5 : 1.1)
                    .foregroundColor(PokemonType.type(from: move.type?.name ?? "").color.background.opacity(0.5))
            }
            VStack() {
                SkillNameView(move: move, level: level)
                    .padding(.top, 30)
                Spacer()
                SkillPowerView(move: move)
                    .padding(.bottom, 30)
            }
        }
        .frame(height: height)
    }
}
