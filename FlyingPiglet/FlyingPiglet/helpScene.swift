//
//  helpScene.swift
//  FlyingPiglet
//
//  Created by Peter Obling on 28/10/2019.
//  Copyright © 2019 Peter Obling. All rights reserved.
//

import SpriteKit

class helpScene: SKScene {

/* UI Connections */
    
var backButton2: MSButtonNode!

    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        backButton2 = self.childNode(withName: "backButton2") as? MSButtonNode

        backButton2.selectedHandler = {
            self.loadBack2()
        }
    }
    
    func loadBack2() {
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
