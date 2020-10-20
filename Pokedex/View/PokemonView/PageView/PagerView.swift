//
//  PagerView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/7/20.
//

import SwiftUI

enum Direction {
    case up
    case down
    case left
    case right
    case non
    
    static func getDirection(value: DragGesture.Value) -> Direction {
        if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
            return .left
        }
        else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
            return .right
        }
        else if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
            return .up
        }
        else if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
            return.down
        } else {
            return .non
        }
    }
}

struct PagerView<Content: View & Identifiable>: View {
    @Binding var index: Int
    @State var offset: CGFloat = 0.0
    var color: Color
    var tabs: [Tab]
    var pages: () -> [Content]
    
    @State private var isGestureActive: Bool = false
    
    private func drag(in size: CGSize) -> some Gesture{
        return DragGesture().onChanged({ value in
            withAnimation(.spring()) {
                self.isGestureActive = true
                self.offset = value.translation.width + -size.width * CGFloat(self.index)
            }
        }).onEnded({ value in
            withAnimation(.spring()) {
                if -value.predictedEndTranslation.width > size.width / 2, self.index < self.pages().endIndex - 1 {
                    self.index += 1
                }
                if value.predictedEndTranslation.width > size.width / 2, self.index > 0 {
                    self.index -= 1
                }
                withAnimation {
                    self.offset = -size.width * CGFloat(self.index)
                }
                self.isGestureActive = false
            }
        })
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                TabControlView(tabs: tabs, color: color,selected: $index, offset: $offset)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(self.pages()) { page in
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
                .onChange(of: index, perform: { _ in
                    withAnimation(.linear) {
                        self.offset = -geometry.size.width * CGFloat(self.index)
                    }
                })
            }
        }
    }
}

struct TabControlView: View {
    var tabs: [Tab]
    var color: Color
    @Binding var selected: Int
    @Binding var offset: CGFloat
    
    @Namespace var namespace
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 1, content: {
                ForEach(tabs, id: \.self) { tab in
                    TabItem(selected: $selected, tab: tab)
                }
            })
            SelectedSegmentScrollView(numberOfSegment: tabs.count, color: color, offset: $offset)
                .frame(height: 3, alignment: .center)
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
