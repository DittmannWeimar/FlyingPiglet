//
//  GameScene.swift
//  FlyingPiglet
//
//  Created by Peter Obling on 25/10/2019.
//  Copyright © 2019 Peter Obling. All rights reserved.
/* Hjælp til brug af AVFoundation er fundet fra https://stackoverflow.com/questions/43178289/ios-create-a-simple-audio-waveform-animation/43179340?fbclid=IwAR38FFalYofN0c5_8T0OIoWl55k_DD43qfj6m6pihtxPm6DR8NmiDMZ5Oas#43179340
*/

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene , SKPhysicsContactDelegate, AVAudioRecorderDelegate , AVAudioPlayerDelegate {
    
    
    //timer score
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    var counter = 0
    var gameStateIsInGame = true
    var score = 0
    var highScore = 0
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var pigSprites = Array<Any>()
    var pig = SKSpriteNode()
    var repeatActionPig = SKAction()
    //* opretter variabler til AVFoundation
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var settings = [String : Int]()
    
    
    
    /* UI Connections */
        
    var backButton4: MSButtonNode!


        override func didMove(to view: SKView) {
            /* Setup your scene here */
            //* Når man kommer til dette SKView oprettes createscene samt scorelabel og highscorelabel
            
            //timer score
            scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.text = "Score: 0"
            scoreLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 250)
            scoreLabel.zPosition = 5
            addChild(scoreLabel)
            
            //highscore
            highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            highScoreLabel.text = "Highscore: "
            highScoreLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 300)
            highScoreLabel.zPosition = 5
            addChild(highScoreLabel)
            
            createScene()
         
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted == false{
       //* når man rør skærmen første gang begynder microphonen at optage og spillet begynder
            
            startRecording()
           
            //1
            isGameStarted =  true
            pig.physicsBody?.affectedByGravity = true
 
            //get highscore when touches began
            let HighscoreDefault = UserDefaults.standard
            
            if (HighscoreDefault.value(forKey: "Highscore") != nil){
                highScore = HighscoreDefault.value(forKey: "Highscore") as! NSInteger
                highScoreLabel.text = NSString(format: "Highscore: %i", highScore) as String
                //UserDefaults.standard.integer(forKey: "Key")
            }
            
            //2
            self.pig.run(repeatActionPig)
            
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
            
            pig.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            pig.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        } else {
            //4
            if isDied == false {
                //* koden under tilader at man kan bruge fingeren til at styre sine hop
                pig.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                pig.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
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
                    
                    //timer score
                    //her får vi timeren til at gå opad
                    //score højere end highscore = ny highscore
                    if gameStateIsInGame {
                        if counter >= 60 {
                            score += 1
                            counter = 0
                        } else {
                            counter += 1
                            scoreLabel.text = NSString(format: "Score: %i", score) as String
                        }
                        if (score > highScore){
                            highScore = score
                            highScoreLabel.text = NSString(format: "Highscore: %i", highScore) as String
                        }
                        
                        //storing highscore with userdefaults
                        var HighscoreDefault = UserDefaults.standard
                        UserDefaults.standard.set(highScore, forKey: "Highscore")
                        UserDefaults.standard.synchronize()
                    }
                    
                    enumerateChildNodes(withName: "background", using: ({
                        (node, error) in
                        let bg = node as! SKSpriteNode
                        bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                        if bg.position.x <= -bg.size.width {
                            bg.position = CGPoint(x:bg.position.x + bg.size.width / 2,
                                                  y:bg.position.y)
                        }
                    }))
                    
                    // * Herunder bruger vi .updateMeters() og .everagePower(forChannel: 0) til at udtrække en værdi der er tilsvarende til hvor højt der bliver råbt ind i microfonen.
                    audioRecorder.updateMeters()
                    let power = audioRecorder.averagePower(forChannel: 0)
                    print(power)
                    
              //* Hvis der bliver råbt højt nok vil grisen bevæge sig oppad.
                   if power > -15 {
                       pig.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                       pig.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 35))
                    
                   }
                    
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
          //  background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        self.pig = createPig()
        self.addChild(pig)
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
                finishRecording(success: false)
                self.pig.removeAllActions()
            }
        
    }
   
}
    
    func loadBack4() {
        
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
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
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        
        /* 3) Start game scene */
        skView.presentScene(scene)
    }
    
    func startRecording() {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            
            // Audio Settings
            settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            
            audioRecorder = try AVAudioRecorder(url: self.directoryURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.isMeteringEnabled = true
            
            
        } catch {
            
            finishRecording(success: false)
        }
        
        do {
            
            try audioSession.setActive(true)
            audioRecorder.record()
            
            
        } catch {
            
        }
    
    }
   // * Denne funktion stopper audiorecorderen når man dør i spillet
    func finishRecording(success: Bool) {
        
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            
            print("Tap to Re-record")
            
            
        } else {
            
            print("Somthing Wrong.")
        }
    }
 //* denne funktion
    func directoryURL() -> URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        print(soundURL!)
        return soundURL!
    }
    
    
    
}
