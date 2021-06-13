//
//  SetGame.swift
//  SetCardGame
//
//  Created by Murty Gudipati on 03/06/21.
//

import Foundation

class SetGame: ObservableObject {
  @Published var deck: [Card]
  @Published var cardsInGame = [Card]()
  @Published var discardedCards = [Card]()
  @Published var score = 0

  var selectedCardsIndices: [Int] {
    cardsInGame.indices.filter { cardsInGame[$0].isSelected }
  }

  var matchedCardsIndices: [Int] {
    cardsInGame.indices.filter { cardsInGame[$0].isMatched }
  }

  var mismatchedCardsIndices: [Int] {
    cardsInGame.indices.filter { cardsInGame[$0].isMismatched }
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
            cards.append(Card(symbol: symbol, color: color, number: number, shading: shading))
          }
        }
      }
    }

    return cards.shuffled()
  }

  func reset() {
    deck = SetGame.createDeck()
    cardsInGame = []
    discardedCards = []
    score = 0
  }

  func hint() {
    // clear all states
    for index in cardsInGame.indices {
      cardsInGame[index].isMatched = false
      cardsInGame[index].isMismatched = false
      cardsInGame[index].isSelected = false
    }

    var card1index = 0
    var card2index = 1

    repeat {
      for card3index in cardsInGame.indices {
        if isSet(indices: [card1index, card2index, card3index]) {
          cardsInGame[card1index].isMatched = true
          cardsInGame[card2index].isMatched = true
          cardsInGame[card3index].isMatched = true
          return
        }
      }

      card1index += 1
      card2index += 1
    } while card2index < cardsInGame.count
  }

  func deal12() {
    guard deck.count >= 12 else { return }
    deal(numberOfCards: 12)
  }

  func deal3() {
    guard deck.count >= 3 else { return }

    if matchedCardsIndices.count == 3 {
      matchedCardsIndices.forEach { index in
        discardedCards.append(cardsInGame[index])
        cardsInGame[index] = deck.removeFirst()
        cardsInGame[index].isFaceUp = true
      }
    } else {
      deal()
    }
  }

  private func deal(numberOfCards: Int = 3) {
    for _ in 1...numberOfCards {
      var card = deck.removeFirst()
      card.isFaceUp = true
      cardsInGame.append(card)
    }
  }

  func choose(_ card: Card) {
    if let chosenIndex = cardsInGame.firstIndex(where: { $0.id == card.id }) {

      // if 3 cards are selected and is a matching set...
      if matchedCardsIndices.count == 3 {
        // select the chosen card if it is not part of the matched set
        if !matchedCardsIndices.contains(chosenIndex) {
          cardsInGame[chosenIndex].isSelected = true
        }

        // move the matched cards to discard pile
        let offsets = IndexSet(matchedCardsIndices)
        for index in offsets {
          discardedCards.append(cardsInGame[index])
        }
        cardsInGame.remove(atOffsets: offsets)

        return
      }

      // if 3 cards are selected and is not a non-maching set...
      if mismatchedCardsIndices.count == 3 {
        // deselect all of them and select the chosen card
        mismatchedCardsIndices.forEach { index in
          cardsInGame[index].isSelected = false
          cardsInGame[index].isMismatched = false
        }
        cardsInGame[chosenIndex].isSelected = true

        return
      }

      // "selection". if 1 or 2 cards in selection, allow "deselection"
      if selectedCardsIndices.count < 3 {
        cardsInGame[chosenIndex].isSelected.toggle()

        // if 3 cards are selected, check for matching (is a set?)
        if selectedCardsIndices.count == 3 {
          if isSet(indices: selectedCardsIndices) {
            score += 1
            selectedCardsIndices.forEach { index in
              cardsInGame[index].isMatched = true
            }
          } else {
            selectedCardsIndices.forEach { index in
              cardsInGame[index].isMismatched = true
            }
          }
        }
      }
    }
  }

  private func isSet(indices: [Int]) -> Bool {
    let card1 = cardsInGame[indices[0]]
    let card2 = cardsInGame[indices[1]]
    let card3 = cardsInGame[indices[2]]

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

  enum Symbol: CaseIterable {
    case oval, squiggle, diamond
  }

  enum Shading: CaseIterable {
    case filled, stroked, shaded
  }

  enum Color: CaseIterable {
    case red, green, purple
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
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var isSelected: Bool = false
    var isMismatched: Bool = false
  }
}
