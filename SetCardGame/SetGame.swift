//
//  SetGame.swift
//  SetCardGame
//
//  Created by Murty Gudipati on 03/06/21.
//

import Foundation

struct SetGame {
  private(set) var cards: [Card]

  init() {
    cards = []

    Symbol.allCases.forEach { symbol in
      Color.allCases.forEach { color in
        Shading.allCases.forEach { shading in
          Number.allCases.forEach { number in
            cards.append(Card(symbol: symbol, color: color, number: number, shading: shading))
          }
        }
      }
    }
  }

  enum Symbol: String, CaseIterable {
    case oval, rectangle, diamond
  }

  enum Shading: String, CaseIterable {
    case filled, outline, striped
  }

  enum Color: String, CaseIterable {
    case red, green, purple
  }

  enum Number: Int, CaseIterable {
    case one = 1, two, three
  }

  struct Card: Identifiable {
    var id = UUID()
    var symbol: Symbol
    var color: Color
    var number: Number
    var shading: Shading
  }
}
