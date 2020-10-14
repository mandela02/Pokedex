//
//  PokedexView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct PokedexView: View {
    @State var active = 5
    @State var showTypeView: Bool = false
    @State var subViewOffset: CGSize = CGSize.zero

    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        
        GeometryReader (content: { geometry in
            ZStack {
                PokemonList()
                    .transition(AnyTransition.move(edge: .leading).combined(with: .opacity))
                    .blur(radius: showTypeView ? 3 : 0)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingMenu(active: $active)
                    }
                }
                
                if showTypeView {
                    Color.black.opacity(0.5)
                    VStack {
                        Spacer()
                        TypeSubView(isShowing: $showTypeView,
                                    offset: $subViewOffset, view: {
                                        AllTypeList().background(Color.white)
                                    })
                            .frame(height: geometry.size.height/2)
                            .transition(AnyTransition
                                            .move(edge: .bottom))
                    }
                    .offset(y: subViewOffset.height)
                }
            }
            .onChange(of: active, perform: { active in
                if active == 1 {
                    withAnimation(.default) {
                        showTypeView = true
                    }
                }
            })
            .onChange(of: showTypeView, perform: { showTypeView in
                if showTypeView == false {
                    active = 5
                    subViewOffset = CGSize.zero
                }
            })
        })
    }
}

struct TypeSubView<Content: View>: View {
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
