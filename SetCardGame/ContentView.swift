//
//  ContentView.swift
//  SetCardGame
//
//  Created by Murty Gudipati on 03/06/21.
//

import SwiftUI

struct ContentView: View {
  var game = SetGame()

  var body: some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
        ForEach(game.cards) { card in
          CardView(card: card)
            .aspectRatio(2/3, contentMode: .fit)
        }
      }
      .padding()
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
