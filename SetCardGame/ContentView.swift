//
//  ContentView.swift
//  SetCardGame
//
//  Created by Murty Gudipati on 03/06/21.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var game = SetGame()
  @Namespace private var dealingNamespace
  @Namespace private var discardingNamespace

  var body: some View {
    VStack {
      HStack {
        deckBody
        Spacer()
        discardPile
      }

      gameBody

      HStack {
        hint
        Spacer()
        Text("Score: \(game.score)")
        Spacer()
        restart
      }
    }
    .padding()
    .onAppear {
      withAnimation {
        game.deal12()
      }
    }
  }

  var restart: some View {
    Button {
      game.reset()
      withAnimation {
        game.deal12()
      }
    } label: {
      Text("Restart")
    }
  }

  var hint: some View {
    Button {
      game.hint()
    } label: {
      Text("Cheat")
    }
  }

  var gameBody: some View {
    ScrollView {
      LazyVGrid(columns: [adaptiveGridItem(width: 60)], spacing: 5) {
        ForEach(game.cardsInGame) { card in
          CardView(card: card)
            .aspectRatio(2/3, contentMode: .fit)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .matchedGeometryEffect(id: card.id, in: discardingNamespace)
            .zIndex(zIndex(of: card))
            .onTapGesture {
              withAnimation {
                game.choose(card)
              }
            }
        }
      }
      .padding(.vertical, 5)
    }
  }

  private func adaptiveGridItem(width: CGFloat) -> GridItem {
    var gridItem = GridItem(.adaptive(minimum: width))
    gridItem.spacing = 5
    return gridItem
  }

  var discardPile: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10).strokeBorder()
      ForEach(game.discardedCards) { card in
        CardView(card: card)
          .matchedGeometryEffect(id: card.id, in: discardingNamespace)
      }
    }
    .frame(width: CardConstants.deckWidth, height: CardConstants.deckHeight)
  }

  var deckBody: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10).strokeBorder()
      ForEach(game.deck) { card in
        CardView(card: card)
          .matchedGeometryEffect(id: card.id, in: dealingNamespace)
          .zIndex(zIndex(of: card))
      }
    }
    .frame(width: CardConstants.deckWidth, height: CardConstants.deckHeight)
    .onTapGesture {
      withAnimation {
        game.deal3()
      }
    }
  }

  private func zIndex(of card: SetGame.Card) -> Double {
    -Double(game.deck.firstIndex(where: { $0.id == card.id }) ?? 0)
  }

  private struct CardConstants {
    static let color = Color.red
    static let aspectRatio: CGFloat = 2/3
    static let dealDuration: Double = 1.0
    static let totalDealDuration: Double = 1.0
    static let deckHeight: CGFloat = 60
    static let deckWidth = deckHeight * aspectRatio
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()

    ContentView()
      .preferredColorScheme(.dark)
  }
}
