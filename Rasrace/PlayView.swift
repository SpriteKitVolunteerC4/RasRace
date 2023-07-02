//
//  PlayView.swift
//  Rasrace
//
//  Created by Muhammad Rezky on 29/06/23.
//

import SwiftUI
import _SpriteKit_SwiftUI

struct PlayView: View {
    @ObservedObject var gameScene: GameScene
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    var body: some View {
        ZStack{
            SpriteView(scene: gameScene)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
            
            
            VStack{
                HStack {
                    Spacer()
                    Text("Score: \(gameScene.score)")
                        .frame(width: 100, height: 50)
                        .background(
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        )
                    Spacer()
                }
                Spacer()
            }
            
        }
    }
}
