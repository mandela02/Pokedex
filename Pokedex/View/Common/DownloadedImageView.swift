//
//  DownloadedImageView.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import SwiftUI

struct DownloadedImageView: View {
    @ObservedObject private var imageLoader: ImageLoader
    @Binding private var image: UIImage?
        
    var needAnimated: Bool
    
    init(withURL url: String, needAnimated: Bool, image: Binding<UIImage?>) {
        self.imageLoader = ImageLoader(url: url)
        self.needAnimated = needAnimated
        self._image = image
    }
    
    var body: some View {
        if needAnimated {
            AnimatedImageView(imageLoader: imageLoader, image: $image)
        } else {
            NormalImageView(imageLoader: imageLoader)
        }
    }
}

struct NormalImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State private var image: UIImage?
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image("pokeball")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onReceive(imageLoader.$displayImage, perform: { displayImage in
                    self.image = displayImage
                })
        }
    }
}

struct AnimatedImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @Binding var image: UIImage?
    @State private var isComplete: Bool = false
    @State private var isStartWigle: Bool = false
    @State private var showSplash: Bool = false
    @State private var showSplashTilted: Bool = false
    @State private var showStrokeBorder: Bool  = false
    @State private var needHidden: Bool  = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(x: isComplete ? 0 : -150)
                        .scaleEffect(isComplete ? 1 : 0)
                        .animation(Animation.easeInOut(duration: 1).delay(0.5))
                        .onAppear(perform: {
                            self.isComplete.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                needHidden = true
                            })
                        })
                } else {
                    Image("pokeball")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onReceive(imageLoader.$displayImage, perform: { displayImage in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                if displayImage != nil {
                                    self.image = displayImage
                                    self.showStrokeBorder = true
                                    self.showSplash = true
                                    self.showSplashTilted = true
                                }
                            })
                        })
                        .rotationEffect(.degrees(isStartWigle ? 0 : 2.5), anchor: .bottom)
                        .onAppear() {
                            // fix bug animation on iphone SE
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                withAnimation(Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true)) {
                                    isStartWigle.toggle()
                                }
                            })
                        }
                }
                ZStack {
                    Circle()
                        .strokeBorder(lineWidth: showStrokeBorder ? 1 : 35/2,
                                      antialiased: false)
                        .opacity(showStrokeBorder ? 0 : 1)
                        .frame(width: 35, height: 35)
                        .foregroundColor(.purple)
                        .scaleEffect(showStrokeBorder ? 1 : 0)
                        .animation(Animation.easeInOut(duration: 0.5))
                        .scaleEffect(7)
                        .isRemove(needHidden)

                    Image("splash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(showSplash ? 0 : 1)
                        .frame(width: 48, height: 48)
                        .scaleEffect(showSplash ? 1 : 0)
                        .animation(Animation.easeInOut(duration: 0.5).delay(0.1))
                        .scaleEffect(7)
                        .isRemove(needHidden)

                    Image("splash_tilted")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(showSplashTilted ? 0 : 1)
                        .frame(width: 50, height: 50)
                        .scaleEffect(showSplashTilted ? 1.1 : 0)
                        .scaleEffect(1.1)
                        .animation(Animation.easeOut(duration: 0.5).delay(0.1))
                        .scaleEffect(7)
                        .isRemove(needHidden)
                }
            }
        }
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
