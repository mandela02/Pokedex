//
//  DownloadedImageView.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import SwiftUI

struct DownloadedImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @Binding var image: UIImage?
    
    init(withURL url: String, image: Binding<UIImage?>) {
        self.imageLoader = ImageLoader(url: url)
        self._image = image
    }
    
    var body: some View {
        Image(uiImage: imageLoader.displayImage ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onReceive(imageLoader.$displayImage, perform: { value in
                self.image = value
            })
    }
}
