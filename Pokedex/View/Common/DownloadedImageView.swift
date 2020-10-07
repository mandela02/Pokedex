//
//  DownloadedImageView.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import SwiftUI

struct DownloadedImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage?
    @Namespace var namespace
        
    init(withURL url: String) {
        self.imageLoader = ImageLoader(url: url)
    }
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .transition(.asymmetric(insertion: .opacity, removal: .opacity))
        } else {
            if let pokeball = UIImage(named: "pokeball") {
                Image(uiImage: pokeball)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onReceive(imageLoader.$displayImage, perform: { value in
                        self.image = value
                    })
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
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
