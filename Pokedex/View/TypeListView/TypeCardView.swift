//
//  TypeCardView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct TappableTypeCardView: View {
    var cell: TypeCell
    var size: (width: CGFloat, height: CGFloat)
    var avatar: Int
    
    @State var show: Bool = false
    
    var body: some View {
        Button {
            show = true
        } label: {
            TypeCardView(cell: cell, size: size, avatar: avatar)
                .background(NavigationLink(destination: TypePokemonListView(cells: cell),
                                           isActive: $show) { EmptyView() })
        }
    }
}

struct TypeCardView: View {
    var cell: TypeCell
    var size: (width: CGFloat, height: CGFloat)
    var avatar: Int
    
    @State var image: UIImage?
    var body: some View {
        ZStack {
            PokemonType.type(from: cell.type.name).color.background
                .ignoresSafeArea().saturation(5.0)
                .blur(radius: 1)
            
            Image("ic_pokeball")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(PokemonType.type(from: cell.type.name).color.background.opacity(0.5))
                .frame(width: size.height * 4/5, height: size.height * 4/5, alignment: .bottomTrailing)
                .offset(x: size.width * 1/4, y: size.height * 1/3 )
                .blur(radius: 1)
            
            VStack {
                Spacer()
                DownloadedImageView(withURL: UrlType.getImageUrlString(of: avatar),
                                    needAnimated: false, image: $image)
                    .frame(width: size.width * 1/2,
                           height: size.height,
                           alignment: .bottomTrailing)
                    .padding(.all, 5)
            }.frame(width: size.width, height: size.height, alignment: .bottomTrailing)
            
            CustomText(text: cell.type.name.uppercased(),
                       size: 30,
                       weight: .black, textColor: .white)
                .frame(width: size.width, height: size.height)
        }
        .frame(width: size.width, height: size.height)
        .background(Color.clear)
        .cornerRadius(25)
        .transition(.opacity)
        .animation(.spring())
        
    }
}

struct TypeCardView_Previews: PreviewProvider {
    static var previews: some View {
        TypeCardView(cell: TypeCell(type: PokeType(id: 1, name: "GROUND",
                                                   pokemon: []), cells: []), size: (250, 200), avatar: 1)
    }
}
