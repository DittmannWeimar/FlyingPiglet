//
//  MainMenu.swift
//  FlyingPiglet
//
//  Created by Peter Obling on 25/10/2019.
//  Copyright © 2019 Peter Obling. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {

/* UI Connections */
var buttonPlay: MSButtonNode!

var helpButton: MSButtonNode!
    
var highButton: MSButtonNode!
    
var settingsButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */

        /* Set UI connections */
        buttonPlay = self.childNode(withName: "buttonPlay") as? MSButtonNode

        buttonPlay.selectedHandler = {
            self.loadGame()
        }
        
        /* Set UI connections */
        helpButton = self.childNode(withName: "helpButton") as? MSButtonNode

        helpButton.selectedHandler = {
            self.loadHelp()
        }
        
        /* Set UI connections */
        highButton = self.childNode(withName: "highButton") as? MSButtonNode

        highButton.selectedHandler = {
            self.loadHigh()
        }
        
        /* Set UI connections */
        settingsButton = self.childNode(withName: "settingsButton") as? MSButtonNode

        settingsButton.selectedHandler = {
            self.loadSetting()
        }
    }
    
    func loadGame() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView? else {
            print("Could not get Skview")
            return
        }

        /* 2) Load Game scene */
        let transition = SKTransition.doorway(withDuration: 1.5) //her lavet med animation af loading HUSK dette nede i start game scene
        guard let scene = GameScene(fileNamed:"GameScene") else {
            print("Could not make GameScene, check the name is spelled correctly")
            return
        }
        
        /* 3) Ensure correct aspect mode */
        scene.scaleMode = .aspectFill

        /* Show debug */
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true

        /* 4) Start game scene */
        skView.presentScene(scene, transition:transition)
    }
    
    
    func loadHelp() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView? else {
            print("Could not get Skview")
            return
        }

        /* 2) Load Game scene */
        guard let scene = helpScene(fileNamed:"helpScene") else {
            print("Could not make GameScene, check the name is spelled correctly")
            return
        }
        
        /* Show debug */
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true

        /* 4) Start game scene */
        skView.presentScene(scene)
    }
    
    
    func loadHigh() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView? else {
            print("Could not get Skview")
            return
        }

        /* 2) Load Game scene */
        guard let scene = highScene(fileNamed:"highScene") else {
            print("Could not make GameScene, check the name is spelled correctly")
            return
        }
        
        /* Show debug */
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true

        /* 4) Start game scene */
        skView.presentScene(scene)
    }
    
    func loadSetting() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView? else {
            print("Could not get Skview")
            return
        }

        /* 2) Load Game scene */
        guard let scene = settingScene(fileNamed:"settingScene") else {
            print("Could not make GameScene, check the name is spelled correctly")
            return
        }
        
        /* Show debug */
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true

        /* 4) Start game scene */
        skView.presentScene(scene)
    }
    
}
