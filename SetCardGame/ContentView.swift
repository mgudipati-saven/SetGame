//
//  ContentView.swift
//  SetCardGame
//
//  Created by Murty Gudipati on 03/06/21.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var game = SetGame()

  var body: some View {
    VStack {
      HStack {
        Button {
          game.deal(numberOfCards: 3)
        } label: {
          Text("Deal 3 More Cards")
        }
        .disabled(game.deck.isEmpty)

        Spacer()

        Button {
          game.reset()
        } label: {
          Text("New Game")
        }
      }
      .padding(.horizontal)

      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
          ForEach(game.cards) { card in
            CardView(card: card)
              .aspectRatio(2/3, contentMode: .fit)
              .onTapGesture {
                game.choose(card)
              }
          }
        }
        .padding()
      }
      .onAppear { game.deal(numberOfCards: 12) }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()

    ContentView()
      .preferredColorScheme(.dark)
  }
}
