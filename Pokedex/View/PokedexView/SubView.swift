//
//  SubView.swift
//  Pokedex
//
//  Created by TriBQ on 15/10/2020.
//

import SwiftUI

enum SubViewKind: Int, CaseIterable {
    case search
    case type
    case region
    case favorite
    
    static func getKind(from index: Int) -> SubViewKind {
        return allCases[safe: index] ?? favorite
    }
}

struct SubView<Content: View>: View {
    @Binding var isShowing: Bool
    @Binding var offset: CGSize
    
    let view: () ->  Content
    
    private func drag(in size: CGSize) -> some Gesture {
        let collapseValue = size.height / 4 - 100
        
        return DragGesture()
            .onChanged({ gesture in
                if gesture.translation.height > 0 {
                    withAnimation(.linear) {
                        self.offset = gesture.translation
                    }
                }
            }).onEnded({ _ in
                withAnimation(.default) {
                    if offset.height > collapseValue {
                        self.offset = size
                    }
                }
                withAnimation(Animation.linear(duration: 0.5)) {
                    self.isShowing = false
                }
            })
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                VStack {
                    HexColor.white
                        .frame(height: 100, alignment: .center)
                        .cornerRadius(25)
                        .offset(y: 50)
                        .gesture(drag(in: geometry.size))
                    view()
                }
                VStack {
                    Capsule().fill(Color(.systemGray3))
                        .frame(width: 100, height: 5, alignment: .center)
                        .offset(y: 60)
                    Spacer()
                }
            }
        })
    }
}

struct TypeSubView: View {
    @Binding var isShowing: Bool
    @Binding var offset: CGSize
    var kind: SubViewKind
    
    var body: some View {
        SubView(isShowing: $isShowing,
                offset: $offset, view: {
                    getView()
                })
            .transition(AnyTransition
                            .move(edge: .bottom))
    }
    
    private func getView() -> AnyView {
        switch kind {
        case .type:
            return AnyView(AllTypeList().background(Color.white))
        case .search:
            return AnyView(SearchView().background(Color.white))
        default:
            return AnyView(EmptyView())
        }
    }
}

struct SearchView: View {
    var body: some View {
        VStack {
            SearchBar()
            Spacer()
        }
    }
}
