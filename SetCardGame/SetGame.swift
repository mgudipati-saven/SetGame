//
//  SetGame.swift
//  SetCardGame
//
//  Created by Murty Gudipati on 03/06/21.
//

import Foundation

class SetGame: ObservableObject {
  private(set) var deck: [Card]

  @Published var cards = [Card]()

  private var selectedCardsIndices: [Int] {
    cards.indices.filter { cards[$0].status == .selected }
  }

  private var matchedCardsIndices: [Int] {
    cards.indices.filter { cards[$0].status == .matched }
  }

  private var mismatchedCardsIndices: [Int] {
    cards.indices.filter { cards[$0].status == .mismatched }
  }

  init() {
    deck = SetGame.createDeck()
  }

  static func createDeck() -> [Card] {
    var cards = [Card]()

    Symbol.allCases.forEach { symbol in
      Color.allCases.forEach { color in
        Shading.allCases.forEach { shading in
          Number.allCases.forEach { number in
            cards.append(Card(symbol: symbol, color: color, number: number, shading: shading, status: Status.none))
          }
        }
      }
    }

    return cards.shuffled()
  }

  func reset() {
    deck = SetGame.createDeck()
    cards = []
    deal(numberOfCards: 12)
  }

  func choose(_ card: Card) {
    if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
      print("Selected Cards: \(selectedCardsIndices)")

      // if 3 cards are selected and is a matching set...
      if matchedCardsIndices.count == 3 {
        print("Matching Cards: \(matchedCardsIndices)")
        // select the chosen card if it is not part of the matched set
        if !matchedCardsIndices.contains(chosenIndex) {
          cards[chosenIndex].status = .selected
        }

        // if deck is not empty, replace with new ones
        if !deck.isEmpty {
          matchedCardsIndices.forEach { index in
            cards[index] = deck.remove(at: 0)
          }
        } else {
          // deck is empty, remove the set
          let offsets = IndexSet(matchedCardsIndices)
          cards.remove(atOffsets: offsets)
        }

        return
      }

      // if 3 cards are selected and is not a non-maching set...
      if mismatchedCardsIndices.count == 3 {
        print("Non-Matching Cards: \(mismatchedCardsIndices)")
        // deselect all of them and select the chosen card
        mismatchedCardsIndices.forEach { index in
          cards[index].status = .none
        }
        cards[chosenIndex].status = .selected

        return
      }

      // "selection". if 1 or 2 cards in selection, allow "deselection"
      if selectedCardsIndices.count < 3 {
        cards[chosenIndex].status = cards[chosenIndex].status == .selected ? .none : .selected

        // if 3 cards are selected, check for matching (is a set?)
        if selectedCardsIndices.count == 3 {
          if isSet(indices: selectedCardsIndices) {
            selectedCardsIndices.forEach { index in
              cards[index].status = .matched
            }
          } else {
            selectedCardsIndices.forEach { index in
              cards[index].status = .mismatched
            }
          }
        }
      }
    }
  }

  private func isSet(indices: [Int]) -> Bool {
    if indices.count == 3 {
      let card1 = cards[indices[0]]
      let card2 = cards[indices[1]]
      let card3 = cards[indices[2]]

      // check if they all have same number or all different numbers
      if haveSameNumber(card1, card2, card3) || haveDifferentNumbers(card1, card2, card3) {
        // check if they all have same symbol or all different symbols
        if haveSameSymbol(card1, card2, card3) || haveDifferentSymbols(card1, card2, card3) {
          // check if they all have same symbol or all different shading
          if haveSameShading(card1, card2, card3) || haveDifferentShadings(card1, card2, card3) {
            // check if they all have same symbol or all different symbols
            if haveSameColor(card1, card2, card3) || haveDifferentColors(card1, card2, card3) {
              return true
            }
          }
        }
      }
    }

    return false
  }

  private func haveSameNumber(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
    (card1.number == card2.number && card2.number == card3.number) ? true : false
  }

  private func haveDifferentNumbers(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
    (card1.number != card2.number && card2.number != card3.number && card3.number != card1.number) ? true : false
  }

  private func haveSameSymbol(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
    (card1.symbol == card2.symbol && card2.symbol == card3.symbol) ? true : false
  }

  private func haveDifferentSymbols(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
    (card1.symbol != card2.symbol && card2.symbol != card3.symbol && card3.symbol != card1.symbol) ? true : false
  }

  private func haveSameShading(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
    (card1.shading == card2.shading && card2.shading == card3.shading) ? true : false
  }

  private func haveDifferentShadings(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
    (card1.shading != card2.shading && card2.shading != card3.shading && card3.shading != card1.shading) ? true : false
  }

  private func haveSameColor(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
    (card1.color == card2.color && card2.color == card3.color) ? true : false
  }

  private func haveDifferentColors(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
    (card1.color != card2.color && card2.color != card3.color && card3.color != card1.color) ? true : false
  }

  func deal(numberOfCards: Int) {
    let numberOfCardsToDeal = min(numberOfCards, deck.count)
    for _ in 0..<numberOfCardsToDeal {
      cards.append(deck.removeFirst())
    }
  }

  enum Symbol: CaseIterable {
    case oval, rectangle, diamond
  }

  enum Shading: CaseIterable {
    case filled, stroked, shaded
  }

  enum Color: CaseIterable {
    case red, green, purple
  }

  enum Status {
    case none, selected, matched, mismatched
  }

  enum Number: Int, CaseIterable {
    case one = 1, two, three
  }

  struct Card: Identifiable {
    let id = UUID()
    let symbol: Symbol
    let color: Color
    let number: Number
    let shading: Shading
    var status: Status
  }
}
