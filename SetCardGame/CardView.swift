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
      RoundedRectangle(cornerRadius: 10)
        .stroke(DrawingConstants.borderColor, lineWidth: 1)

      RoundedRectangle(cornerRadius: 10)
        .fill(fillColor)

      VStack {
        ForEach(0..<card.number.rawValue, id: \.self) { _ in
          symbol
            .aspectRatio(2/1, contentMode: .fit)
        }
      }
      .foregroundColor(color)
      .padding()
    }
  }

  var fillColor: Color {
    switch card.status {
      case .none:
        return Color.white
      case .selected:
        return Color(.systemGray6)
      case .matched:
        return Color.green.opacity(0.1)
      case .mismatched:
        return Color.pink.opacity(0.2)
    }
  }

  @ViewBuilder
  var symbol: some View {
    switch card.shading {
      case .filled:
        filledSymbol
      case .stroked:
        strokedSymbol
      case .shaded:
        shadedSymbol
    }
  }

  @ViewBuilder
  var strokedSymbol: some View {
    switch card.symbol {
      case .oval:
        RoundedRectangle(cornerRadius: 100)
          .stroke(lineWidth: 4)
      case .diamond:
        Diamond()
          .stroke(lineWidth: 4)
      case .squiggle:
        Squiggle()
          .stroke(lineWidth: 4)
    }
  }

  @ViewBuilder
  var filledSymbol: some View {
    switch card.symbol {
      case .oval:
        RoundedRectangle(cornerRadius: 100)
          .fill()
      case .diamond:
        Diamond()
          .fill()
      case .squiggle:
        Squiggle()
          .fill()
    }
  }

  @ViewBuilder
  var shadedSymbol: some View {
    ZStack {
      filledSymbol.opacity(0.2)
      strokedSymbol
    }
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

  struct DrawingConstants {
    static let borderColor = Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5)
  }
}

struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    CardView(
      card: SetGame.Card(
        symbol: SetGame.Symbol.squiggle,
        color: SetGame.Color.red,
        number: SetGame.Number.three,
        shading: SetGame.Shading.shaded,
        status: SetGame.Status.mismatched
      )
    )
    .frame(width: 150, height: 200)
    .previewLayout(.sizeThatFits)
  }
}
