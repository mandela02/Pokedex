//
//  HeaderImageScrollView.swift
//  Pokedex
//
//  Created by TriBQ on 16/10/2020.
//

import SwiftUI

struct HeaderImageScrollView: View {
    @Binding var index: Int
    
    var items: [String]
    var onEndScrolling: (Direction) -> ()
    
    @State var image: UIImage?
    @State private var isGestureActive: Bool = false
    @State var offset: CGFloat = 0.0
    
    private func drag(in size: CGSize) -> some Gesture {
        return DragGesture().onChanged({ value in
            withAnimation(.spring()) {
                self.isGestureActive = true
                self.offset = value.translation.width + -size.width * CGFloat(self.index)
            }
        }).onEnded({ value in
            var direction: Direction = .up
            withAnimation(.spring()) {
                if -value.predictedEndTranslation.width > size.width / 2, self.index < self.items.endIndex - 1 {
                    self.index += 1
                    direction = .right
                    onEndScrolling(direction)
                } else if value.predictedEndTranslation.width > size.width / 2, self.index > 0 {
                    self.index -= 1
                    direction = .left
                    onEndScrolling(direction)
                }
                withAnimation {
                    self.offset = -size.width * CGFloat(self.index)
                }
                self.isGestureActive = false
            }
        })
    }
    
    func ImageView(image: String, tag: Int, size: CGSize) -> some View {
        return DownloadedImageView(withURL: image,
                                   style: index == tag ? .normal : .silhoutte)
            .foregroundColor(.black)
            .blur(radius: index == tag ? 0 : 4.0)
            .scaleEffect(index == tag ? 1.5 : 0.7)
            .frame(width: size.width, height: size.height)
    }
    
    var body: some View {
        GeometryReader { geometry in
            LazyHStack(alignment: .center, spacing: 0) {
                ForEach(Array(zip(items.indices, items)), id: \.0) { index, item in
                    if item.isEmpty {
                        Color.clear .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        ImageView(image: item, tag: index, size: geometry.size)
                    }
                }
            }
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
