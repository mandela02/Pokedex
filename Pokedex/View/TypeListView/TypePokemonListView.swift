//
//  TypePokemonListView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct TypePokemonListView: View {
    @EnvironmentObject var voiceUpdater: VoiceHelper

    @State var isLoading = false
    @Binding var show: Bool

    var typeCell : TypeCell
        
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = geometry.size.height / 6
            ZStack {
                VStack {
                    List {
                        ForEach(typeCell.cells) { cell in
                            PokemonListCellView(firstPokemon: cell.firstPokemon,
                                                secondPokemon: cell.secondPokemon)
                                .listRowInsets(EdgeInsets())
                                .frame(width: geometry.size.width, height: height)
                                .padding(.bottom, 10)
                                .listRowBackground(Color.clear)
                                .environmentObject(voiceUpdater)
                        }
                    }
                    .animation(.linear)
                    .listStyle(SidebarListStyle())
                    .blur(radius: isLoading ? 3.0 : 0)
                }
                
                VStack {
                    Spacer()
                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0),
                                                               Color.white.opacity(1)]),
                                   startPoint: .top, endPoint: .bottom)
                        .frame(height: 100, alignment: .center)
                        .blur(radius: 3.0)
                }
                
                if isLoading {
                    LoadingView()
                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                }
                                
            }
            .ignoresSafeArea()
            .onAppear(perform: {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isLoading = false
                }
            })
            .navigationTitle(typeCell.type.name.capitalizingFirstLetter())
            .background(NavigationConfigurator { nc in
                nc.navigationBar.setBackgroundImage(UIImage(), for: .default)
                nc.navigationBar.backgroundColor = .clear
                nc.navigationBar.isTranslucent = true
                nc.navigationBar.shadowImage = UIImage()
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
            })
        })
    }
}

struct BackButtonView: View {
    @Binding var isShowing: Bool
    
    @State var isFavorite = false

    var body: some View {
            HStack{
                Button {
                    withAnimation(.spring()){
                        isShowing = false
                    }
                } label: {
                    Image(systemName: ("arrow.uturn.left"))
                        .renderingMode(.template)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.clear)
                        .clipShape(Circle())
                }
                .frame(width: 50, height: 50, alignment: .center)
                Spacer()
            }
            .padding(.top, UIDevice().hasNotch ? 44 : 8)
            .padding(.horizontal)
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}
