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
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene {
    
    func createPig() -> SKSpriteNode {
    //1 laver grisen som en SKSpriteNode og tildeler den en texture med størrelse og placering på skærmen
    let pig = SKSpriteNode(imageNamed: "Piglet")
    pig.size = CGSize(width: 50, height: 50)
    pig.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
    //2 tildeler grisen en Physicsbody
    pig.physicsBody = SKPhysicsBody(circleOfRadius: pig.size.width / 2)
    pig.physicsBody?.linearDamping = 1.1
    pig.physicsBody?.restitution = 0
    //3 tildeler CollisionBitMask til grisen så den kan opfatte collision med pillars
    pig.physicsBody?.categoryBitMask = CollisionBitMask.pigletCategory
    pig.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
    pig.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
    //4
    pig.physicsBody?.affectedByGravity = false
    pig.physicsBody?.isDynamic = true
    
    return pig
    }
    func createWalls() -> SKNode  {
    // 1
    wallPair = SKNode()
    wallPair.name = "wallPair"
    
    let topWall = SKSpriteNode(imageNamed: "piller")
    let btmWall = SKSpriteNode(imageNamed: "piller")
    
    topWall.position = CGPoint(x: self.frame.width - 650, y: self.frame.height / 2 + 150)
    btmWall.position = CGPoint(x: self.frame.width - 650, y: self.frame.height / 2 - 850)
    
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
    // 3 tildeler en random position på y-aksen for pillarne 
    let randomPosition = random(min: -150, max: 150)
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
