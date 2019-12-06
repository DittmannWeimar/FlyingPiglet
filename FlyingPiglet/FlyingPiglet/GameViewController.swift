//
//  GameViewController.swift
//  FlyingPiglet
//
//  Created by Peter Obling on 25/10/2019.
//  Copyright © 2019 Peter Obling. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController, AVAudioRecorderDelegate , AVAudioPlayerDelegate{

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Load 'SceneSelection.sks' as a GKScene. This provides gameplay related content
       
        
        // spørger om tilladelse til at bruge microfonen 
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        if let scene = GKScene(fileNamed: "MainMenu") {
                            // Get the SKScene from the loaded SceneSelection
                            if let sceneNode = scene.rootNode as! MainMenu? {
                                // Set the scale mode to scale to fit the window
                                sceneNode.scaleMode = .aspectFill
                                // Present the scene
                                if let view = self.view as! SKView? {
                                    view.presentScene(sceneNode)
                                    view.ignoresSiblingOrder = false
                                    view.showsFPS = false
                                    view.showsNodeCount = false
                                    
                                }
                            }
                        }
                        
                     //* Uncomment this code and comment out all other code in the if statment above to start the game when the app starts
                      //  self.loadFirstScene()
                        
                    } else {
                        
                        self.failedFirstLoad()
                     
                        
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
  
    
    func failedFirstLoad() {
    
        return(); 
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
