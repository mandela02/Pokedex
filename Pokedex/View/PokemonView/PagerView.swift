//
//  PagerView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/7/20.
//

import SwiftUI

struct TextView: View, Identifiable {
    var id = UUID()
    var text: String
    
    var body: some View {
        GeometryReader(content: { geometry in
            Rectangle().fill(Color.white)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        })
    }
}

struct PagerView<Content: View & Identifiable>: View {
    @Binding var index: Int
    @Binding var offset: CGFloat
    
    @State private var isGestureActive: Bool = false

    var pages: [Content]

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(self.pages) { page in
                        page
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .background(Color.clear)
                    }
                }
            }
            .content
            .offset(x: self.isGestureActive ? self.offset : -geometry.size.width * CGFloat(self.index))
            .frame(width: geometry.size.width, height: nil, alignment: .leading)
            .gesture(DragGesture().onChanged({ value in
                self.isGestureActive = true
                self.offset = value.translation.width + -geometry.size.width * CGFloat(self.index)
            }).onEnded({ value in
                if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.pages.endIndex - 1 {
                    self.index += 1
                }
                if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                    self.index -= 1
                }
                withAnimation {
                    self.offset = -geometry.size.width * CGFloat(self.index)
                }
                self.isGestureActive = false
            }), including: .all)
            .onChange(of: index, perform: { value in
                withAnimation(.linear) {
                    self.offset = -geometry.size.width * CGFloat(self.index)
                }
            })
        }
    }
}
