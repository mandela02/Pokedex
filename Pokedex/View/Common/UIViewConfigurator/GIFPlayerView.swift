//
//  GifView.swift
//  Pokedex
//
//  Created by TriBQ on 18/10/2020.
//

import Foundation
import SwiftUI

class GIFPlayerView: UIView {
    private let imageView = UIImageView()
    
    convenience init(gifName: String) {
        self.init()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let gif = UIImage.gifImageWithURL(gifName)
            DispatchQueue.main.async {
                self.imageView.image = gif
                self.imageView.contentMode = .scaleAspectFit
                self.addSubview(self.imageView)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}


struct GIFView: UIViewRepresentable {
    var gifName: String

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<GIFView>) {}


    func makeUIView(context: Context) -> UIView {
        return GIFPlayerView(gifName: gifName)
    }
}

