//
//  AnimatedSwitch.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 24/11/2020.
//

import SwiftUI

struct AnimatedSwitch: View {
    @Binding var isOn: Bool
    var body: some View {
        AnimatedSwitchContent(isOn: $isOn)
            .onTapGesture(count: 1, perform: {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    isOn.toggle()
                }
            })
    }
}

struct AnimatedSwitchContent: View {
    @Binding var isOn: Bool

    var body: some View {
        GeometryReader(content: { geometry in
            let width = geometry.size.width
            let height = width * 0.3
            ZStack(alignment: .center) {
                MountainView(isOn: $isOn, size: CGSize(width: width, height: height))
                    .cornerRadius(height/2)
                    .frame(width: width, height: height, alignment: .center)
                    .clipped()
                Capsule()
                    .fill(Color.clear)
                    .overlay(
                        HStack {
                            if !isOn {
                                Spacer()
                                    .frame(width: width - height)
                            }
                            Circle()
                                .fill(Color.white)
                                .scaleEffect(0.9)
                            if isOn {
                                Spacer()
                                    .frame(width: width - height)
                            }
                        }
                    )
            }.frame(width: width, height: height, alignment: .leading)
        }).frame(alignment: .center)
    }
}

struct MountainView: View {
    @Binding var isOn: Bool
    var size: CGSize
        
    var body: some View {
        ZStack {
            Color.white
            Color.yellow
                .opacity( isOn ? 0 : 0.2)
            Color.black
                .opacity( isOn ? 0.7 : 0)

            SunView(isOn: $isOn, size: CGSize(width: size.height, height: size.height))
                .offset(y: size.height/1.5)
                .rotationEffect(.degrees(isOn ? -120 : 120))
                .offset(y: size.width/20)
            
            "mountain_large"
                .image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(y: isOn ? size.width/20 : size.width/10)
            "mountain_medium"
                .image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(y: isOn ? size.width/40 : size.width/15)
                .offset(y: size.width/20)
            "mountain_small"
                .image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(y: isOn ? size.width/15 : size.width/10)
                .offset(y: size.width/20)
            
            if isOn {
                "tree"
                    .image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(1.3)
                    .transition(AnyTransition.move(edge: .bottom))
                    .animation(.default)
            }
        }
        .scaleEffect(1.2)
    }
}

struct SunView: View {
    @Binding var isOn: Bool
    var size: CGSize
    var dayConic: RadialGradient
    var nightConic: RadialGradient
    @State var conic: RadialGradient?

    init(isOn: Binding<Bool>, size: CGSize) {
        self._isOn = isOn
        self.size = size
        dayConic = RadialGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.5), Color.white]),
                               center: .center,
                               startRadius: size.width * 0.3,
                               endRadius: size.width * 0.5)
        nightConic = RadialGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.black]),
                               center: .center,
                               startRadius: size.width * 0.3,
                               endRadius: size.width * 0.5)

    }
    
    var body: some View {
        ZStack {
            if let conic = conic {
                Circle()
                    .fill(Color.clear)
                    .overlay(conic)
                    .blur(radius: 15)
            }
            Circle()
                .fill(Color.white)
                .scaleEffect(0.3)
                .blur(radius: 2)
        }.frame(width: size.width, height: size.width, alignment: .center)
        .onChange(of: isOn, perform: { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.conic = value ? self.nightConic : self.dayConic
                }
            }
        }).onAppear {
            self.conic = isOn ? self.nightConic : self.dayConic
        }
    }
}

struct AnimatedSwitch_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedSwitch(isOn: .constant(true))
    }
}
