//
//  FavoriteView.swift
//  Pokedex
//
//  Created by TriBQ on 18/10/2020.
//

import SwiftUI

struct FavoriteView: View {
    @Binding var show: Bool
    
    var body: some View {
        GeometryReader(content: { geometry in
            //            let size = geometry.size
            
            ZStack {
                //                Image("ic_pokeball")
                //                    .resizable()
                //                    .renderingMode(.template)
                //                    .aspectRatio(contentMode: .fit)
                //                    .foregroundColor(Color(.systemGray4))
                //                    .scaleEffect(0.8)
                //                    .blur(radius: 3)
                
                RotatingPokeballView(color: Color(.systemGray4))
                    .scaleEffect(1.2)
                //                    .frame(width: size.width, height: size.height, alignment: .center)
                //                    .offset(x: -(size.width * 1/4 + 25), y: size.height * 3/5)
                
                FavoriteListView(show: $show)
                VStack {
                    VStack {
                        HStack(alignment: .center) {
                            BackButtonView(isShowing: $show)
                            Spacer()
                        }
                        Text("Your Favorite Pokemon")
                            .font(Biotif.extraBold(size: 30).font)
                            .foregroundColor(.black)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                    }
                    .padding(.top, 25)
                    .padding(.leading, 20)
                    .background(Color.white.opacity(0.5))
                    Spacer()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .ignoresSafeArea()
        })
    }
}

struct FavoriteListView: View {
    @StateObject var favoriteUpdater: FavoriteUpdater = FavoriteUpdater()
    @Binding var show: Bool
        
    var didChange =  NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = (geometry.size.width - 20) / 2 * 0.7
            PokemonList(cells: $favoriteUpdater.cells,
                        isLoading: .constant(false),
                        isFinal: .constant(false),
                        paddingHeader: 80,
                        paddingFooter: 50,
                        cellSize: CGSize(width: geometry.size.width - 10, height: height)) { _ in }
                .onReceive(didChange) { _ in
                    favoriteUpdater.fetchEntries()
                }
        })
    }
}
