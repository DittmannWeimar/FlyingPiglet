//
//  GameScene.swift
//  FlyingPiglet
//
//  Created by Peter Obling on 25/10/2019.
//  Copyright © 2019 Peter Obling. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
   // let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
 //   var score = Int(0)
//    var scoreLbl = SKLabelNode()
//    var highscoreLbl = SKLabelNode()
 //   var taptoplayLbl = SKLabelNode()
 //   var restartBtn = SKSpriteNode()
//    var pauseBtn = SKSpriteNode()
//    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    //CREATE THE BIRD ATLAS FOR ANIMATION
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<Any>()
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
    /* UI Connections */
        
    var backButton4: MSButtonNode!


        override func didMove(to view: SKView) {
            /* Setup your scene here */
            createScene()
            /* Set UI connections */
   //         backButton4 = self.childNode(withName: "backButton4") as? MSButtonNode

//            backButton4.selectedHandler = {
  //              self.loadBack4()
   //         }
        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted == false{
            //1
            isGameStarted =  true
            bird.physicsBody?.affectedByGravity = true
            
            //2
 //           logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
   //             self.logoImg.removeFromParent()
    //        })
      //      taptoplayLbl.removeFromParent()
            //3
            self.bird.run(repeatActionBird)
            
            //1
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
            })
            //2
            let delay = SKAction.wait(forDuration: 1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            //3
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePillars = SKAction.moveBy(x: +distance + 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePillars = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePillars, removePillars])
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        } else {
            //4
            if isDied == false {
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
       
            if isDied == true{
                
                loadBack4()
            }
        
    }
    
        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
            if isGameStarted == true{
                if isDied == false{
                    enumerateChildNodes(withName: "background", using: ({
                        (node, error) in
                        let bg = node as! SKSpriteNode
                        bg.position = CGPoint(x: bg.position.x + 2, y: bg.position.y)
                        if bg.position.x <= -bg.size.width {
                            bg.position = CGPoint(x:bg.position.x + bg.size.width / 2,
                                                  y:bg.position.y)
                        }
                    }))
                }
            }
        }
    
    
    func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.pigletCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.pigletCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "background1")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        //SET UP THE BIRD SPRITES FOR ANIMATION
        birdSprites.append(birdAtlas.textureNamed("piglet"))
        birdSprites.append(birdAtlas.textureNamed("piglet1"))
        
        self.bird = createBird()
        self.addChild(bird)
        
        //PREPARE TO ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animateBird = SKAction.animate(with: self.birdSprites as! [SKTexture], timePerFrame: 0.1)
        self.repeatActionBird = SKAction.repeatForever(animateBird)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.pigletCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.pigletCategory || firstBody.categoryBitMask == CollisionBitMask.pigletCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.pigletCategory{
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if isDied == false{
                isDied = true
           //     createRestartBtn()
           //     pauseBtn.removeFromParent()
                self.bird.removeAllActions()
            }
        
    }
   
}
    
    func loadBack4() {
        
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        //   score = 0
        createScene()
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView? else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = SKScene(fileNamed:"MainMenu") else {
            print("Could not make GameScene, check the name is spelled correctly")
            return
        }
        
        /* Show debug */
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        /* 3) Start game scene */
        skView.presentScene(scene)
    }
    
}
