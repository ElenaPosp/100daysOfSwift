//
//  GameScene.swift
//  Project11
//
//  Created by Елена Поспелова on 18/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    let ballImages = ["ballBlue", "ballCyan","ballGreen","ballGrey","ballPurple","ballRed","ballYellow"]

    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet { scoreLabel.text = "Score: \(score)" }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var ballsLabel: SKLabelNode!
    var ballsLeft: Int = 0 {
        didSet { ballsLabel.text = "Balls left: \(ballsLeft)" }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        setupLabels()

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self

        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    func setupLabels() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)

        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)

        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLeft = 5
        ballsLabel.position = CGPoint(x: 280, y: 700)
        addChild(ballsLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1),
                                                      green: CGFloat.random(in: 0...1),
                                                      blue: CGFloat.random(in: 0...1),
                                                      alpha: 1),
                                       size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                
                addChild(box)
            } else {
                if location.y < 500 || ballsLeft == 0 { return }
                let ball = SKSpriteNode(imageNamed: ballImages.randomElement() ?? "ballRed")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = location
                ball.name = "ball"
                addChild(ball)
                ballsLeft -= 1
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bounser = SKSpriteNode(imageNamed: "bouncer")
        bounser.position = position
        bounser.physicsBody = SKPhysicsBody(circleOfRadius: bounser.size.width/2)
        bounser.physicsBody?.isDynamic = false
        addChild(bounser)
    }
    
    private func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
    }
    
    func collision(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(obj: ball)
            score += 1
            ballsLeft += 1
        } else if object.name == "bad" {
            destroy(obj: ball)
            score -= 1
        }
    }
    
    func destroy(obj: SKNode) {
        if let fire = SKEmitterNode(fileNamed: "FireParticles") {
            fire.position = obj.position
            addChild(fire)
        }
        obj.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard
            let nodeA = contact.bodyA.node,
            let nodeB = contact.bodyB.node
        else { return }
        if nodeA.name == "ball" {
            collision(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(ball: nodeB, object: nodeA)
        }
    }
}
