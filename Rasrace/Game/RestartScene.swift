//
//  RestartScene.swift
//  Rasrace
//
//  Created by Muhammad Rezky on 30/06/23.
//

import SpriteKit
import SwiftUI

class RestartScene: SKScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            if (node.name == "restart-button") {
                goToGameScene()
            }
        }
    }
    
    func goToGameScene(){
        self.removeAllActions()
        self.removeFromParent()
        self.removeAllChildren()
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(scene)
    }

}
