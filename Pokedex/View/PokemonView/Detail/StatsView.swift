//
//  StatsView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/8/20.
//

import SwiftUI

enum PokeStat: Int, CaseIterable {
    case hp
    case attack
    case defense
    case spAtk
    case spDef
    case speed
    case total
    
    var title: String {
        switch self {
        case .hp:
            return "HP"
        case .attack:
            return "Attack"
        case .defense:
            return "Defense"
        case .spAtk:
            return "Sp.Atk"
        case .spDef:
            return "Sp.Def"
        case .speed:
            return "Speed"
        case .total:
            return "Total"
        }
    }
    
    var maxValue: Int {
        switch self {
        case .total:
            return (PokeStat.allCases.count - 1) * 100
        default:
            return 100
        }
    }
}

struct StatsView: View {
    @ObservedObject var updater: StatUpdater
    @Binding var selectedIndex: Int

    init(pokemon: Pokemon, selectedIndex: Binding<Int>) {
        self.updater = StatUpdater(of: pokemon)
        self._selectedIndex = selectedIndex
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                VStack(spacing: 10) {
                    ForEach(updater.numbers) { pokeStat in
                        if let stat = pokeStat.stat {
                            LevelInformationView(stat: stat,
                                                 amount: pokeStat.baseStat,
                                                 selectedIndex: $selectedIndex)
                        }
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                if !updater.characteristics.isEmpty {
                    VStack(alignment: .leading, spacing: 5, content: {
                        Text("Characteristics")
                            .font(.custom("Biotif-Bold", size: 15))
                            .foregroundColor(.black)
                        FlexibleGridView(characteristics: $updater.descriptions)
                    })
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)

                }
                Spacer()
            }.padding(.top, 20)
            Color.clear.frame(height: 150, alignment: .center)
        }
        .animation(.linear)
    }
}

struct LevelInformationView: View {
    let stat: PokeStat
    let amount: Int
    @Binding var selectedIndex: Int
    @State var isLoading: Bool = false

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(stat.title)
                .font(.custom("Biotif-Bold", size: 12))
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            Text("\(amount)")
                .font(.custom("Biotif-Bold", size: 12))
                .foregroundColor(.black)
                .frame(width: 30, alignment: .leading)
                .padding(.trailing, 10)
            LevelBar(level: amount,
                     maxLevel: stat.maxValue, isLoading: $isLoading)
                .frame(height: 3, alignment: .center)
        }
        .onChange(of: selectedIndex) { index in
            isLoading = index == Tab.stats.rawValue
        }
    }
}

struct LevelBar: View {
    let level: Int
    let maxLevel: Int
    @Binding var isLoading: Bool

    var body: some View {
        GeometryReader(content: { geometry in
            let ratio = level >= maxLevel ? 1 : CGFloat(level)/CGFloat(maxLevel)
            let redWidth = geometry.size.width * ratio
            
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 3, height: 3))
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: geometry.size.width, alignment: .center)
                    .clipped()
                HStack {
                    RoundedRectangle(cornerSize: CGSize(width: 3, height: 3))
                        .trim(from: 0, to: 1)
                        .fill(Color.red)
                        .frame(width: isLoading ? redWidth : 0, alignment: .center)
                        .clipped()
                        .animation(Animation.easeIn(duration: 1))
                    Spacer()
                }
            }
        })
    }
}
