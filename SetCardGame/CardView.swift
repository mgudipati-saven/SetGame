//
//  CardView.swift
//  SetCardGame
//
//  Created by Murty Gudipati on 03/06/21.
//

import SwiftUI

struct CardView: View {
  var card: SetGame.Card

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10).fill(Color.white)
      RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray))
      VStack {
        ForEach(1..<card.number.rawValue+1) { number in
          switch card.symbol {
            case .oval:
              view(for: RoundedRectangle(cornerRadius: 100))
            case .rectangle:
              view(for: RoundedRectangle(cornerRadius: 0))
            case .diamond:
              view(for: Diamond())
          }
        }
      }
      .foregroundColor(color)
      .padding()
    }
  }

  @ViewBuilder
  func view<T:Shape>(for shape: T) -> some View {
    ZStack {
      shape
        .fill()
        .opacity(opacity)
        .padding(2)

      shape
        .stroke(lineWidth: 4)
    }
    .aspectRatio(2/1, contentMode: .fit)
    .padding(.bottom)
  }

  var color: Color {
    switch card.color {
      case .green:
        return Color.green
      case .purple:
        return Color.purple
      case .red:
        return Color.red
    }
  }

  var opacity: Double {
    switch card.shading {
      case .filled:
        return 1.0
      case .outline:
        return 0.0
      case .striped:
        return 0.2
    }
  }
}

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

struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    CardView(
      card: SetGame.Card(
        symbol: SetGame.Symbol.oval,
        color: SetGame.Color.red,
        number: SetGame.Number.two,
        shading: SetGame.Shading.outline
      )
    )
  }
}
