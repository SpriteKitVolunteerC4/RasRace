//
//  GameScene.swift
//  Rasrace
//
//  Created by Muhammad Rezky on 22/06/23.
//

import SpriteKit


class GameScene: SKScene {
    
    
    
    var player: SKSpriteNode = SKSpriteNode(imageNamed: "PlayerSprite")
    
    var opponent: SKSpriteNode = SKSpriteNode(imageNamed: "Car1Sprite")
    
    var road: SKSpriteNode = SKSpriteNode(imageNamed: "road")
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        initRoad()
        initPlayer()
        initOpponent()
        
    }
    
    func initPlayer(){
        player.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 100)
        addChild(player)
    }
    
    func generateOpponentPosition() -> CGPoint {
        let sectionWidth = UIScreen.main.bounds.width / 3
        
        // Choose a random section for the opponent
        let randomSection = Int.random(in: 0...2)
        
        var opponentXPosition: CGFloat
        
        switch randomSection {
        case 0:
            // Left section
            opponentXPosition = sectionWidth / 2
        case 1:
            // Middle section
            opponentXPosition = UIScreen.main.bounds.width / 2
        case 2:
            // Right section
            opponentXPosition = UIScreen.main.bounds.width - (sectionWidth / 2)
        default:
            // Default to middle section if something unexpected happens
            opponentXPosition = UIScreen.main.bounds.width / 2
        }
        return CGPoint(x: opponentXPosition, y: UIScreen.main.bounds.height - 100)
    }
    
    func initOpponent() {
        opponent.position = generateOpponentPosition()
        // sequence
        let moveDown = SKAction.moveTo(y: 0, duration: 10)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveDown, remove])
        opponent.run(sequence)
        
        addChild(opponent)
    }
    
    func initRoad(){
        let startFirstY = road.size.height/2
        let startSecondY = road.size.height/2 - 200
        let endY = -road.size.height/2 + UIScreen.main.bounds.height
        
        road.size = CGSize(width: UIScreen.main.bounds.width, height: road.size.height)
//        Awal
                road.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: startFirstY)
        
//        Tujuan
//        road.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: -road.size.height/2 + UIScreen.main.bounds.height)
        

        let moveDown = SKAction.moveTo(y: endY, duration: 4 )
        let reset = SKAction.moveTo(y: startSecondY, duration: 0 )
        let sequence = SKAction.sequence([moveDown, reset])
        let repeatForever = SKAction.repeatForever(sequence)
        road.run(repeatForever)
        addChild(road)
        
    }
    
    func moveSprites(sprite : SKSpriteNode, speed : Float) -> Void {
            var newPosition = CGPointZero
            
          
                
                newPosition = sprite.position
                newPosition.x -= CGFloat(speed * 1)
                sprite.position = newPosition
                
                if sprite.frame.maxX < self.frame.minX {
                    
                    sprite.position =
                    CGPoint(x: sprite.position.x +
                            sprite.size.width * 3,
                            y: sprite.position.y)
                }
                
            
        }
     
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let screenWidth = UIScreen.main.bounds.width
            let sectionWidth = screenWidth / 3
            
            player.position.y = location.y
            
            if location.x <= sectionWidth {
                // Move to the left section
                player.position.x = sectionWidth / 2
            } else if location.x <= sectionWidth * 2 {
                // Move to the middle section
                player.position.x = screenWidth / 2
            } else {
                // Move to the right section
                player.position.x = screenWidth - (sectionWidth / 2)
            }
        }
    }
    
    
    
}
