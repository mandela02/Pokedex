//
//  CustomBigTitleNavigationView.swift
//  Pokedex
//
//  Created by TriBQ on 20/10/2020.
//

import SwiftUI

struct CustomBigTitleNavigationView<Content, Header, StickyHeader>: View where Content: View, Header: View, StickyHeader: View {
    
    var content: () -> Content
    var header: () -> Header
    var stickyHeader: () -> StickyHeader
    var maxHeight: CGFloat
    
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 1
    @State var isExpanded = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    GeometryReader { reader -> AnyView in
                        return AnyView(
                            header()
                                .onChange(of: reader.frame(in: .global).minY + maxHeight, perform: { y in
                                    let ratio = CGFloat(reader.frame(in: .global).minY/maxHeight)
                                    opacity = 1 + Double(ratio)
                                    if ratio < 0 {
                                        scale = 1 + ratio
                                    }
                                    if y < 0 {
                                        withAnimation(.linear){ isExpanded = true}
                                    }
                                    else {
                                        withAnimation(.linear){isExpanded = false}
                                    }
                                })
                                .frame(height: maxHeight)
                                .offset(y: -reader.frame(in: .global).minY)
                                .opacity(opacity)
                                .scaleEffect(scale)
                        )
                    }
                    .frame(height: maxHeight)
                    
                    content()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                }
            }
            
            stickyHeader()
                .opacity(isExpanded ? 1 : 0)
        })
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarHidden(true)
    }
}
