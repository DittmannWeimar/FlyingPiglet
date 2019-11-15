//
//  GameElements.swift
//  FlyingPiglet
//
//  Created by Bent Hansen on 01/11/2019.
//  Copyright © 2019 Peter Obling. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let pigletCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
  //  static let flowerCategory:UInt32 = 0x1 &lt;&lt; 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene {
    
    func createBird() -> SKSpriteNode {
    //1
    let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("piglet"))
    bird.size = CGSize(width: 50, height: 50)
    bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
    //2
    bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
    bird.physicsBody?.linearDamping = 1.1
    bird.physicsBody?.restitution = 0
    //3
    bird.physicsBody?.categoryBitMask = CollisionBitMask.pigletCategory
    bird.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
    bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
    //4
    bird.physicsBody?.affectedByGravity = false
    bird.physicsBody?.isDynamic = true
    
    return bird
    }
    func createWalls() -> SKNode  {
    // 1
    
    // 2
    wallPair = SKNode()
    wallPair.name = "wallPair"
    
    let topWall = SKSpriteNode(imageNamed: "piller")
    let btmWall = SKSpriteNode(imageNamed: "piller")
    
    topWall.position = CGPoint(x: self.frame.width - 450, y: self.frame.height / 2 + 420)
    btmWall.position = CGPoint(x: self.frame.width - 450, y: self.frame.height / 2 - 420)
    
    topWall.setScale(0.5)
    btmWall.setScale(0.5)
    
    topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
    topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
    topWall.physicsBody?.collisionBitMask = CollisionBitMask.pigletCategory
    topWall.physicsBody?.contactTestBitMask = CollisionBitMask.pigletCategory
    topWall.physicsBody?.isDynamic = false
    topWall.physicsBody?.affectedByGravity = false
    
    btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
    btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
    btmWall.physicsBody?.collisionBitMask = CollisionBitMask.pigletCategory
    btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.pigletCategory
    btmWall.physicsBody?.isDynamic = false
    btmWall.physicsBody?.affectedByGravity = false
    
    topWall.zRotation = CGFloat.pi
    
    wallPair.addChild(topWall)
    wallPair.addChild(btmWall)
    
    wallPair.zPosition = 1
    // 3
    let randomPosition = random(min: -200, max: 200)
    wallPair.position.y = wallPair.position.y + randomPosition
    
    
    wallPair.run(moveAndRemove)
    
    return wallPair
    }
    func random() -> CGFloat{
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
    return random() * (max - min) + min
    }
}
