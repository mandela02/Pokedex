//
//  ErrorHandlerUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 27/10/2020.
//

import Combine
import Foundation
import SwiftUI

enum ApiError: Equatable {
    case internet(message: String)
    case non
}

struct FailAlert: ViewModifier {
    @Binding var error: ApiError
    @State var isTopView: Bool = false
    @State var showAlert: Bool = false
    @State var message: String = ""

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Something happend!").font(Biotif.extraBold(size: 30).font),
                      message: Text(message).font(Biotif.bold(size: 15).font),
                      dismissButton: .default(Text("OK").font(Biotif.medium(size: 15).font)))
            }).onAppear {
                isTopView = true
            }.onDisappear {
                isTopView = false
            }.onChange(of: error) { error in
                switch error {
                case .internet(message: let message):
                    self.message = message
                    showAlert = isTopView
                case .non:
                    showAlert = false
                }
            }
    }
}

extension View {
    func showAlert(error: Binding<ApiError>) -> some View {
        self.modifier(FailAlert(error: error))
    }
    
    @ViewBuilder func showErrorView() -> some View {
        switch Network.reachability?.status {
        case .unreachable:
            NoWifiImage()
        default:
            self
        }
    }
}

struct NoInternetView: View {
    var body: some View {
        VStack {  
            Text("No internet connection, please try again later!")
                .font(Biotif.regular(size: 20).font)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.red)
            Spacer()
        }
    }
}

struct NoWifiImage: View {
    var body: some View {
        ZStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200, alignment: .center)
        }
    }
}
