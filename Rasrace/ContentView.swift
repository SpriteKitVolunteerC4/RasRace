//
//  ContentView.swift
//  Rasrace
//
//  Created by Muhammad Rezky on 22/06/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject private var gameScene = GameScene(size: UIScreen.main.bounds.size)
    
    var body: some View {
        ZStack {
            if !gameScene.isGameOver {
                HStack {
                    Text("Score: ")
                    Text("\(gameScene.score)")
                }
                .frame(width: 100, height: 50)
                .background(
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                )
                .zIndex(1)
                .position(x: 75, y: 100)
            }
            
            if gameScene.isGameOver {
                VStack {
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Button() {
                        gameScene.restart()
                    }label: {
                        Text("Restart")
                            .font(.title)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .zIndex(1)
            }
            
            SpriteView(scene: gameScene)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                .blur(radius: gameScene.isGameOver ? 10 : 0)
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
