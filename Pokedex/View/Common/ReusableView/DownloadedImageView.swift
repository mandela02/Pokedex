//
//  DownloadedImageView.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import SwiftUI
import Combine

enum LoadStyle {
    case animated
    case normal
    case silhoutte
    case plain
}

struct DownloadedImageView: View {
    @ObservedObject private var imageLoader: ImageLoader
    var style: LoadStyle
    
    init(withURL url: String, style: LoadStyle) {
        self.imageLoader = ImageLoader(url: url)
        self.style = style
    }
    
    var body: some View {
        VStack {
            switch style {
            case .normal:
                NormalImageView(imageLoader: imageLoader)
            case .animated:
                AnimatedImageView(imageLoader: imageLoader)
            case .silhoutte:
                SilhoutteImageView(imageLoader: imageLoader)
            case .plain:
                PlainImageView(imageLoader: imageLoader)
            }
        }
    }
}

struct SilhoutteImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State private var image: UIImage?
    
    var body: some View {
        if let image = imageLoader.displayImage {
            Image(uiImage: image)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
        } else {
            Image("pokeball")
                .resizable()
                .scaleEffect(0.8)
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct PlainImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    var body: some View {
            Image(uiImage: imageLoader.displayImage ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
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
                .scaleEffect(imageLoader.isSuccess ? 1 : 0.8)
        } else {
            Image("pokeball")
                .resizable()
                .scaleEffect(0.8)
                .aspectRatio(contentMode: .fit)
                .onReceive(imageLoader.$displayImage, perform: { displayImage in
                    withAnimation(.linear) {
                        self.image = displayImage
                    }
                })
        }
    }
}

struct AnimatedImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State private var isDoneLoading = false
    @State private var trigger = false
    @State private var needHidden = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isDoneLoading {
                    HStack {
                        Spacer()
                        ZoomOutImageView(image: imageLoader.displayImage ?? UIImage())
                        Spacer()
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            needHidden = true
                        })
                    }
                } else {
                    HStack {
                        Spacer()
                        WigglePokeBallView(imageLoader: imageLoader)
                        Spacer()
                    }
                    .onReceive(imageLoader.$displayImage, perform: { displayImage in
                        if displayImage != nil {
                            self.isDoneLoading = true
                            self.trigger = true
                        }
                    })
                }
                ExposionView(trigger: $trigger, needHidden: $needHidden)
            }
        }
    }
}

struct ExposionView: View {
    @Binding var trigger: Bool
    @Binding var needHidden: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(lineWidth: trigger ? 1 : 35/2,
                              antialiased: false)
                .opacity(trigger ? 0 : 1)
                .frame(width: 35, height: 35)
                .foregroundColor(.purple)
                .scaleEffect(trigger ? 1 : 0.01)
                .animation(Animation.easeInOut(duration: 0.5))
                .scaleEffect(7)
                .isRemove(needHidden)
            
            Image("splash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(trigger ? 0 : 1)
                .frame(width: 48, height: 48)
                .scaleEffect(trigger ? 1 : 0.01)
                .animation(Animation.easeInOut(duration: 0.5).delay(0.1))
                .scaleEffect(7)
                .isRemove(needHidden)
            
            Image("splash_tilted")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(trigger ? 0 : 1)
                .frame(width: 50, height: 50)
                .scaleEffect(trigger ? 1.1 : 0.01)
                .scaleEffect(1.1)
                .animation(Animation.easeOut(duration: 0.5).delay(0.1))
                .scaleEffect(7)
                .isRemove(needHidden)
        }
    }
}

struct WigglePokeBallView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    @State private var isStartWigle: Bool = false
    
    var body: some View {
        Image("pokeball")
            .resizable()
            .scaleEffect(0.8)
            .aspectRatio(contentMode: .fit)
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
}

struct ZoomOutImageView: View {
    var image: UIImage?
    @State private var isComplete: Bool = false
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(x: isComplete ? 0 : -150)
                .scaleEffect(isComplete ? 1 : 0.01)
                .animation(Animation.easeInOut(duration: 1).delay(0.5))
                .onAppear(perform: {
                    self.isComplete = true
                })
        }
    }
}
