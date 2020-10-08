//
//  PagerView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/7/20.
//

import SwiftUI

struct PagerView<Content: View & Identifiable>: View {
    @Binding var index: Int
    @Binding var offset: CGFloat
    
    @State private var isGestureActive: Bool = false

    var pages: [Content]

    private func drag(in size: CGSize) -> some Gesture{
        return DragGesture().onChanged({ value in
            self.isGestureActive = true
            self.offset = value.translation.width + -size.width * CGFloat(self.index)
        }).onEnded({ value in
            if -value.predictedEndTranslation.width > size.width / 2, self.index < self.pages.endIndex - 1 {
                self.index += 1
            }
            if value.predictedEndTranslation.width > size.width / 2, self.index > 0 {
                self.index -= 1
            }
            withAnimation {
                self.offset = -size.width * CGFloat(self.index)
            }
            self.isGestureActive = false
        })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(self.pages) { page in
                        page
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .background(HexColor.white)
                    }
                }
            }
            .content
            .offset(x: self.isGestureActive ? self.offset : -geometry.size.width * CGFloat(self.index))
            .frame(width: geometry.size.width, height: nil, alignment: .leading)
            .gesture(drag(in: geometry.size))
            .onChange(of: index, perform: { value in
                withAnimation(.linear) {
                    self.offset = -geometry.size.width * CGFloat(self.index)
                }
            })
        }
    }
}

struct TextView: View, Identifiable {
    var id = UUID()
    var text: String
    
    var body: some View {
        GeometryReader(content: { geometry in
            Rectangle().fill(HexColor.white)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        })
    }
}
