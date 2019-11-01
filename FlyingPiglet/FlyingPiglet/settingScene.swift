//
//  settingScene.swift
//  FlyingPiglet
//
//  Created by Peter Obling on 28/10/2019.
//  Copyright © 2019 Peter Obling. All rights reserved.
//

import SpriteKit

class settingScene: SKScene {

/* UI Connections */
    
var backButton3: MSButtonNode!

    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        backButton3 = self.childNode(withName: "backButton3") as? MSButtonNode

        backButton3.selectedHandler = {
            self.loadBack3()
        }
    }
    
    func loadBack3() {
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
