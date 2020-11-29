//
//  RegionListCellView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 20/11/2020.
//

import SwiftUI

struct RegionListCellView: View {
    var size: CGSize
    var region: RegionCellModel
    @State var isShow = false
    
    var body: some View {
        TapToPushView(show: $isShow) {
            RegionListCellContentView(size: size, region: region)
        } destination: {
            RegionDetailView(regionModel: region, isShowing: $isShow)
        }

    }
}
struct RegionListCellContentView: View {
    var size: CGSize
    var region: RegionCellModel
    
    var firstImage: String
    var secondImage:String
    var thirdImage: String
    
    init(size: CGSize, region: RegionCellModel) {
        self.size = size
        self.region = region
        
        firstImage = UrlString.getImageUrlString(of: region.avatars[safe: 0] ?? 0)
        secondImage = UrlString.getImageUrlString(of: region.avatars[safe: 1] ?? 0)
        thirdImage = UrlString.getImageUrlString(of: region.avatars[safe: 2] ?? 0)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                Color.red
                    .frame(height: size.height - 20, alignment: .center)
                Image("ic_pokeball")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .opacity(0.3)
                    .frame(height: size.height - 30, alignment: .center)
            }
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.red.opacity(0.5), lineWidth: 5)
            )
            VStack {
                Spacer()
                ZStack(alignment: .center) {
                    HStack {
                        DownloadedImageView(withURL: firstImage,
                                            style: .normal)
                            .frame(width: size.width / 3)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        DownloadedImageView(withURL: secondImage,
                                            style: .normal)
                            .frame(width: size.width / 3)
                    }

                    DownloadedImageView(withURL: thirdImage,
                                        style: .normal)
                        .frame(width: size.width / 3)
                        .scaleEffect(1.5)
                }
            }
            
            ZStack(alignment: .top) {
                Text(region.name.uppercased())
                    .foregroundColor(.white)
                    .font(Biotif.bold(size: 30).font)
                    .frame(height: size.height - 20, alignment: .center)
                    .shadow(color: .red, radius: 1)
            }
            
        }.frame(width: size.width, height: size.height, alignment: .center)
    }
}
