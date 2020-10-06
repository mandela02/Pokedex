//
//  DownloadedImageView.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import SwiftUI

struct DownloadedImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(withURL url: String) {
        imageLoader = ImageLoader(url: url)
    }
    
    var body: some View {
        Image(uiImage: imageLoader.displayImage ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
