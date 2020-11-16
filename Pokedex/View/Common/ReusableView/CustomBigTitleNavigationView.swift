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
    @State var isHide = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    GeometryReader { reader -> AnyView in
                        let yAxis = reader.frame(in: .global).minY + maxHeight
                        
                        DispatchQueue.main.async {
                            let ratio = CGFloat(reader.frame(in: .global).minY/maxHeight)
                            opacity = 1 + Double(ratio)
                            if ratio < 0 {
                                scale = 1 + ratio
                            } else {
                                scale = 1 + ratio / 3
                            }
                        }
                        
                        if yAxis < 0 && !isHide {
                            DispatchQueue.main.async {
                                withAnimation{ isHide = true }
                            }
                        }
                        
                        if yAxis > 0 && isHide {
                            DispatchQueue.main.async {
                                withAnimation{ isHide = false }
                            }
                        }
                        
                        return AnyView(header()
                                        .frame(height: maxHeight)
                                        .opacity(opacity)
                                        .scaleEffect(scale))
                    }.frame(height: maxHeight)
                    
                    content()
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(15)
                    
                    Color.clear.frame(height: 100)
                }
            }
            
            stickyHeader()
                .opacity(isHide ? 1 : 0)
        })
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isHide = false
            }
        }
    }
}
