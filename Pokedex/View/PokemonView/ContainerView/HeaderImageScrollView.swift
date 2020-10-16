//
//  HeaderImageScrollView.swift
//  Pokedex
//
//  Created by TriBQ on 16/10/2020.
//

import SwiftUI

struct HeaderImageScrollView: View {
    @Binding var index: Int
    @State var offset: CGFloat = 0.0
    @Binding var items: [UIImage?]
    @Binding var isScrollable: Bool

    @State private var isGestureActive: Bool = false
    var onScrolling: (DragGesture.Value) -> ()
    var onEndScrolling: (DragGesture.Value) -> ()

    private func drag(in size: CGSize) -> some Gesture {
        return DragGesture().onChanged({ value in
            if isScrollable {
                withAnimation(.spring()) {
                    self.isGestureActive = true
                    self.offset = value.translation.width + -size.width * CGFloat(self.index)
                    onScrolling(value)
                }
            }
        }).onEnded({ value in
            withAnimation(.spring()) {
                if isScrollable {
                    if -value.predictedEndTranslation.width > size.width / 2, self.index < self.items.endIndex - 1 {
                        self.index += 1
                    }
                    if value.predictedEndTranslation.width > size.width / 2, self.index > 0 {
                        self.index -= 1
                    }
                    withAnimation {
                        self.offset = -size.width * CGFloat(self.index)
                    }
                    self.isGestureActive = false
                    onEndScrolling(value)
                }
            }
        })
    }
    
    func ImageView(image: UIImage?, tag: Int, size: CGSize) -> some View {
        Image(uiImage: image ?? UIImage())
            .resizable()
            .renderingMode(index == tag ? .original : .template)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.black)
            .blur(radius: index == tag ? 0 : 3.0)
            .scaleEffect(index == tag ? 1.4 : 0.6)
            .frame(width: size.width, height: size.height)
            .animation(.default)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(Array(zip(items.indices, items)), id: \.0) { index, item in
                            ImageView(image: item, tag: index, size: geometry.size)
                        }
                    }
                }
                .content
                .offset(x: self.isGestureActive ? self.offset : -geometry.size.width * CGFloat(self.index))
                .frame(width: geometry.size.width, height: nil, alignment: .leading)
                .gesture(drag(in: geometry.size))
                .onChange(of: index, perform: { _ in
                    withAnimation(.linear) {
                        self.offset = -geometry.size.width * CGFloat(self.index)
                    }
                })
            }
        }
    }
}
