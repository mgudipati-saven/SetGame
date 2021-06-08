//
//  Diamond.swift
//  SetCardGame
//
//  Created by Murty Gudipati on 07/06/21.
//

import SwiftUI

struct Diamond: Shape {
  func path(in rect: CGRect) -> Path {
    var p = Path()

    p.move(to: CGPoint(x: 0, y: rect.midY))
    p.addLine(to: CGPoint(x: rect.midX, y: 0))
    p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
    p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
    p.addLine(to: CGPoint(x: 0, y: rect.midY))

    return p
  }
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        Diamond()
    }
}
