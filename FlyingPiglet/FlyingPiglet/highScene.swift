//
//  highScene.swift
//  FlyingPiglet
//
//  Created by Peter Obling on 28/10/2019.
//  Copyright © 2019 Peter Obling. All rights reserved.
//
import SpriteKit

class HighScene: SKScene {

/* UI Connections */
    
var backButton1: MSButtonNode!

    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        backButton1 = self.childNode(withName: "backButton1") as? MSButtonNode

        backButton1.selectedHandler = {
            self.loadBack1()
        }
    }
    
    func loadBack1() {
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
    
}
