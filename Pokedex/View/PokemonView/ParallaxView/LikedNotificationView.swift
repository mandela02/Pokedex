//
//  LikedNotificationView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/26/20.
//

import SwiftUI

struct LikedNotificationView: View {
    @State var liked = false
    
    var id: Int
    var name: String
    var image: String

    let width = UIScreen.main.bounds.width / 2
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).blur(radius: 3)
            VStack {
                DownloadedImageView(withURL: image, style: .normal)
                    .padding(.all, 10)
                HStack {
                    HeartView(isFavorite: $liked) {
                        return
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(name.capitalized)
                            .font(Biotif.regular(size: 20).font)
                        Text(String(format: "#%03d", id))
                            .font(Biotif.regular(size: 15).font)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
            }
            .frame(width: width, height: width, alignment: .center)
            .background(Color.white)
            .cornerRadius(20)
        }.ignoresSafeArea()
        .onAppear(perform: {
            liked = true
        })
    }
}

//struct LikedNotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LikedNotificationView()
//    }
//}
