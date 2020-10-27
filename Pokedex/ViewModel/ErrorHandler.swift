//
//  ErrorHandlerUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 27/10/2020.
//

import Combine
import Foundation
import SwiftUI

class ErrorHandler: ObservableObject {
    let objectWillChange = PassthroughSubject<String, Never>()

    @Published var isHavingError = false {
        didSet {
            objectWillChange.send(message)
        }
    }
    @Published var message = ""
    
    func createAlert(text: String) {
        message = text
        isHavingError = true
    }
    
    func dismissAlert() {
        isHavingError = false
    }
    
    func alert() -> Alert {
        Alert(title: Text("Something happend!").font(Biotif.extraBold(size: 30).font),
              message: Text(message).font(Biotif.bold(size: 15).font),
              dismissButton: .default(Text("OK").font(Biotif.medium(size: 15).font)))
    }
}

struct FailAlert: ViewModifier {
    @EnvironmentObject var errorHandler: ErrorHandler
    @State var isTopView: Bool = false
    @State var showAlert: Bool = false

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert, content: {
                errorHandler.alert()
            }).onAppear {
                isTopView = true
            }.onDisappear {
                isTopView = false
            }.onReceive(errorHandler.$isHavingError) { isError in
                showAlert = isError && isTopView
            }
    }
}

extension View {
    func showAlertIfCallApiFail() -> some View {
        self.modifier(FailAlert())
    }
}
