//
//  GameScene.swift
//  Project11
//
//  Created by Елена Поспелова on 18/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 215, y: 0))
        makeBouncer(at: CGPoint(x: 500, y: 0))
        makeBouncer(at: CGPoint(x: 740, y: 0))
        makeBouncer(at: CGPoint(x: 1000, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.restitution = 0.4
        ball.position = location
        addChild(ball)
    
    }
    
    func makeBouncer(at position: CGPoint) {
        let bounser = SKSpriteNode(imageNamed: "bouncer")
        bounser.position = position
        bounser.physicsBody = SKPhysicsBody(circleOfRadius: bounser.size.width/2)
        bounser.physicsBody?.isDynamic = false
        addChild(bounser)
    }
}

