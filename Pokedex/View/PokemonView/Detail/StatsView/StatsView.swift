//
//  StatsView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/8/20.
//

import SwiftUI

struct StatsView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    @StateObject var updater: StatUpdater = StatUpdater()
    @Binding var selectedIndex: Int
    var pokemon: Pokemon
    
    init(pokemon: Pokemon, selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
        self.pokemon = pokemon
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
                            .font(Biotif.bold(size: 15).font)
                            .foregroundColor(isDarkMode ? .white : .black)
                        FlexibleGridView(characteristics: $updater.descriptions,
                                         foreground: isDarkMode ? .black : .white)
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
        .onAppear {
            updater.pokemon = pokemon
        }
    }
}

struct LevelInformationView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    let stat: PokeStat
    let amount: Int
    @Binding var selectedIndex: Int
    @State var isLoading: Bool = false

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(stat.title)
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            Text("\(amount)")
                .font(Biotif.bold(size: 12).font)
                .foregroundColor(isDarkMode ? .white :.black)
                .frame(width: 30, alignment: .leading)
                .padding(.trailing, 10)
            LevelBar(level: amount,
                     maxLevel: stat.maxValue, isLoading: $isLoading)
                .frame(height: 3, alignment: .center)
        }
        .onChange(of: selectedIndex) { index in
            isLoading = index == Tab.stats.rawValue
        }
        .onAppear {
            isLoading = true
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
