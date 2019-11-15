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

class GameViewController: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()
    // Load 'SceneSelection.sks' as a GKScene. This provides gameplay related content
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    /*
    // including entities and graphs.
    if let scene = GKScene(fileNamed: "MainMenu") {
        // Get the SKScene from the loaded SceneSelection
        if let sceneNode = scene.rootNode as! MainMenu? {
            // Copy gameplay related content over to the scene
            //sceneNode.entities = scene.entities      KOMMENTERET UD DET GAV FEJL
            //sceneNode.graphs = scene.graphs          KOMMENTERET UD DET GAV FEJL

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
    } */
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
