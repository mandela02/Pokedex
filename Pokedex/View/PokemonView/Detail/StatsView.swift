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
    
    init(pokemon: Pokemon) {
        self.updater = StatUpdater(of: pokemon)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                VStack(spacing: 10) {
                    ForEach(updater.numbers) { pokeStat in
                        if let stat = pokeStat.stat {
                            LevelInformationView(stat: stat,
                                                 amount: pokeStat.baseStat)
                        }
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                if !updater.characteristics.isEmpty {
                    VStack(alignment: .leading, spacing: 5, content: {
                        CustomText(text: "Characteristics", size: 15, weight: .bold, textColor: .black)
                        DescriptionView(characteristics: $updater.descriptions)
                    })
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)

                }
                Spacer()
            }.padding(.top, 20)
        }
        .animation(.linear)
    }
}

struct LevelInformationView: View {
    let stat: PokeStat
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

struct DescriptionView: View {
    @Binding var characteristics: [String]

    @State private var totalHeight
          = CGFloat.zero       // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.characteristics, id: \.self) { characteristic in
                self.item(for: characteristic)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > geometry.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if let last = characteristics.last, characteristic == last {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {_ in
                        let result = height
                        if let last = characteristics.last, characteristic == last {
                            height = 0
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func item(for text: String) -> some View {
        Text(text)
            .font(.system(size: 12))
            .padding(.all, 5)
            .font(.body)
            .background(HexColor.lightGrey)
            .foregroundColor(Color.white)
            .cornerRadius(6)
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(pokemon: Pokemon())
    }
}
