//
//  StatsView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/8/20.
//

import SwiftUI

enum Stat: Int, CaseIterable {
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
            return (Stat.allCases.count - 1) * 100
        default:
            return 100
        }
    }
}

struct StatsView: View, Identifiable {
    var id = UUID()
    let pokemon = Pokemon()
    
    var numbers: [PokeStat] = []
    
    init(pokemon: Pokemon) {
        numbers = pokemon.stats
        let allStat = pokemon.stats.map({$0.baseStat}).reduce(0, +)
        numbers.append(PokeStat(statUrl: NamedAPIResource(name: "Total", url: ""), baseStat: allStat))
    }
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 10) {
                ForEach(numbers) { pokeStat in
                    if let stat = pokeStat.stat {
                        LevelInformationView(stat: stat,
                                             amount: pokeStat.baseStat)
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)


            CustomText(text: "Type defenses", size: 15, weight: .bold, textColor: .black)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.trailing, 20)

            CustomText(text: "Type defenses Type defenses Type defenses Type defenses Type defenses Type defenses Type defenses Type defenses Type defenses",
                       size: 12,
                       weight: .bold,
                       textColor: .gray)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            Spacer()
        }.padding(.top, 20)
    }
}

struct LevelInformationView: View {
    let stat: Stat
    let amount: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            CustomText(text: stat.title, size: 12, weight: .bold, textColor: .gray)
                .frame(width: 80, alignment: .leading)
            CustomText(text: "\(amount)", size: 12, weight: .bold, textColor: .black)
                .frame(width: 30, alignment: .leading)
                .padding(.trailing, 10)
            LevelBar(level: amount,
                     maxLevel: stat.maxValue)
                .frame(height: 3, alignment: .center)
        }
    }
}

struct LevelBar: View {
    let level: Int
    let maxLevel: Int
    
    var body: some View {
        GeometryReader(content: { geometry in
            let ratio = level >= maxLevel ? 1 : CGFloat(level)/CGFloat(maxLevel)
            let redWidth = geometry.size.width * ratio
            
            HStack(alignment: .center, spacing: 0) {
                Rectangle().fill(Color.red)
                    .frame(width: redWidth, alignment: .center)
                    .clipped()
                Rectangle().fill(Color.gray.opacity(0.5))
                    .frame(width: geometry.size.width - redWidth, alignment: .center)
                    .clipped()
            }
        })
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(pokemon: Pokemon())
    }
}
