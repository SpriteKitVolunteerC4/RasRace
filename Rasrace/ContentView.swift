//
//  ContentView.swift
//  Rasrace
//
//  Created by Muhammad Rezky on 22/06/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        SpriteView(scene: GameScene(size: UIScreen.main.bounds.size))
            .edgesIgnoringSafeArea(.all)
            .ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
