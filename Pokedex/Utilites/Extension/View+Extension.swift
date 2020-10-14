//
//  View+Extension.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 9/25/20.
//  Copyright © 2020 komorebi. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
    
    @ViewBuilder func isRemove(_ remove: Bool) -> some View {
        if !remove {
            self
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder func isPlaceholder(_ placeholder: Bool) -> some View {
        if placeholder {
            self.redacted(reason: .placeholder)
        } else {
            self.unredacted()
        }
    }
    
    @ViewBuilder func addGesture<T>(isAddable: Bool, gesture: T) -> some View where T: Gesture {
        if isAddable {
            self.highPriorityGesture(gesture)
        }
    }
}

extension View {
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        self.modifier(WillDisappearModifier(callback: perform))
    }
}
