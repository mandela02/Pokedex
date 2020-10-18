//
//  FlexibleGridView.swift
//  Pokedex
//
//  Created by TriBQ on 11/10/2020.
//

import SwiftUI

struct FlexibleGridView: View {
    @Binding var characteristics: [String]

    @State private var totalHeight
    //      = CGFloat.zero       // << variant for ScrollView/List
        = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        //.frame(height: totalHeight)// << variant for ScrollView/List
        .frame(maxHeight: totalHeight) // << variant for VStack
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
            .font(Biotif.regular(size: 12).font)
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
