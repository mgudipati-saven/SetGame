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
      if card.isFaceUp {
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.white)

        RoundedRectangle(cornerRadius: 10)
          .strokeBorder(borderColor, lineWidth: borderWidth)

        VStack(spacing: 8) {
          ForEach(0..<card.number.rawValue, id: \.self) { _ in
            symbol
              .aspectRatio(2/1, contentMode: .fit)
          }
        }
        .foregroundColor(color)
        .padding(10)
      } else {
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.black)
      }
    }
  }

  var borderWidth: CGFloat {
    return card.isMatched || card.isMismatched || card.isSelected ? 3 : 1
  }

  var borderColor: Color {
    if card.isMatched {
      return DrawingConstants.matchingColor
    } else if card.isMismatched {
      return DrawingConstants.mismatchingColor
    } else if card.isSelected {
      return DrawingConstants.selectedColor
    }

    return DrawingConstants.borderColor
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
    static let matchingColor = Color.green
    static let mismatchingColor = Color.red
    static let selectedColor = Color.black
  }
}

struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    var card = SetGame.Card(
      symbol: SetGame.Symbol.squiggle,
      color: SetGame.Color.red,
      number: SetGame.Number.three,
      shading: SetGame.Shading.shaded
    )
    card.isFaceUp = true
//    card.isSelected = true
    card.isMatched = true
//    card.isMismatched = true

    return CardView(card: card)
      .frame(width: 100, height: 150)
      .previewLayout(.sizeThatFits)
  }
}
