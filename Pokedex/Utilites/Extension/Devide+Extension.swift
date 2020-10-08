//
//  Devide+Extension.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/8/20.
//

import Foundation
import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
