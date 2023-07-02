//
//  GameScene.swift
//  Rasrace
//
//  Created by Muhammad Rezky on 22/06/23.
//

import SpriteKit
import SwiftUI


class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject{
    @Published var isGameOver: Bool = false
    @Published var score: Int = 0
    
    var time: Timer?
    // Time of last frame
    var lastFrameTime : TimeInterval = 0
    // Time since last frame
    var deltaTime : TimeInterval = 0
    
    
    var player: SKSpriteNode = SKSpriteNode(imageNamed: "PlayerSprite")
    var opponent: SKSpriteNode = SKSpriteNode(imageNamed: "Car1Sprite")
    var opponents: [SKSpriteNode] = []
    var road: SKSpriteNode = SKSpriteNode(imageNamed: "road")
    var roads: [SKSpriteNode] = []
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func goToRestartScene(){
        self.removeAllActions()
        self.removeFromParent()
        self.removeAllChildren()
        let scene = SKScene(fileNamed: "RestartScene.sks")
        scene!.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(scene)
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        player = SKSpriteNode(imageNamed: "PlayerSprite")
        opponent = SKSpriteNode(imageNamed: "Car1Sprite")
        opponents = []
        
        initRoad()
        initPlayer()
        initOpponent()
        
        time = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.contactTestBitMask = 2
        player.physicsBody?.collisionBitMask = 0
        
        opponent.physicsBody = SKPhysicsBody(rectangleOf: opponent.size)
        opponent.physicsBody?.categoryBitMask = 2
        opponent.physicsBody?.contactTestBitMask = 1
        opponent.physicsBody?.collisionBitMask = 0
        
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        
        deltaTime = currentTime - lastFrameTime
        
        lastFrameTime = currentTime
        
        self.moveRoad(sprites: roads, speed: 250)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

            for touch in touches {
                let location = touch.location(in: self)
                let screenWidth = UIScreen.main.bounds.width
                let sectionWidth = screenWidth / 3
                var positionX = screenWidth / 2
                player.position.y = location.y
                
                if location.x <= sectionWidth {
                    // Move to the left section
                    positionX = sectionWidth / 2
                } else if location.x <= sectionWidth * 2 {
                    // Move to the middle section
                    positionX = screenWidth / 2
                } else {
                    // Move to the right section
                    positionX = screenWidth - (sectionWidth / 2)
                }
                
                let move = SKAction.moveTo(x: positionX, duration: 0.1)
                
                let sequence = SKAction.sequence([move])
                player.run(sequence)
            }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        isGameOver = true
        goToRestartScene()
    }
    
    func initPlayer(){
        player.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 100)
        addChild(player)
    }
    
    func generateOpponentPosition(i: Int = 1) -> CGPoint {
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
        return CGPoint(x: opponentXPosition, y: UIScreen.main.bounds.height + CGFloat(Int.random(in: 50..<(100 * i + 1))))
    }
    
    func initOpponent() {
        opponent.position = generateOpponentPosition()
        let moveDown = SKAction.moveTo(y: 0, duration: 10)
        let remove = SKAction.removeFromParent()
        
        let checkPosition = SKAction.run {
            if self.opponent.position.y <= 0 {
                self.score += 1
            }
        }
        
        let sequence = SKAction.sequence([moveDown, checkPosition, remove])
        opponent.run(sequence)
        addChild(opponent)
    }
    
    func initRoad() {
//        let startFirstY = road.size.height/2
        road.size = CGSize(width: UIScreen.main.bounds.width, height: road.size.height)
        road.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 0)
        roads.append(road.copy() as! SKSpriteNode)
        road.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: road.size.height)
        roads.append(road.copy() as! SKSpriteNode)
        
        addChild(roads[0])
        addChild(roads[1])
    }
    
    func moveRoad(sprites : [SKSpriteNode], speed : Float) -> Void {
        var newPosition = CGPointZero
        
        for spriteToMove in sprites {
            
            newPosition = spriteToMove.position
            newPosition.y -= CGFloat(speed * Float(deltaTime))
            spriteToMove.position = newPosition
            
            if spriteToMove.frame.maxY < self.frame.minY {
                
                spriteToMove.position =
                CGPoint(x: spriteToMove.position.x,
                        y: spriteToMove.position.y +
                        spriteToMove.size.height * 2)
            }
            
        }
    }
    
    func generateCars() {
        let cars: [String] = ["Car1Sprite", "Car2Sprite", "Car3Sprite"]
        let enemy: SKSpriteNode = SKSpriteNode(imageNamed: cars[Int.random(in: 0..<(cars.count - 1))])
        
        enemy.position = generateOpponentPosition()
        let moveDown = SKAction.moveTo(y: 0, duration: 10)
        let remove = SKAction.removeFromParent()
        let checkPosition = SKAction.run {
            if enemy.position.y <= 0 {
                self.score += 1
            }
        }
        let sequence = SKAction.sequence([moveDown, checkPosition, remove])
        enemy.run(sequence)
        opponents.append(enemy)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: opponent.size)
        enemy.physicsBody?.categoryBitMask = 2
        enemy.physicsBody?.contactTestBitMask = 1
        enemy.physicsBody?.collisionBitMask = 0
        addChild(enemy)
    }
    
    @objc func timerFired() {
        generateCars()
    }
}

