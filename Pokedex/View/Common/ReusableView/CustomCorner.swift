//
//  CustomCorner.swift
//  Pokedex
//
//  Created by TriBQ on 08/11/2020.
//

import SwiftUI

struct CustomCorner: Shape {
    var corner: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: 35, height: 35))
         
        return Path(path.cgPath)
    }
}
