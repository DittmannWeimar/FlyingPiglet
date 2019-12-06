//
//  SwiftUIView.swift
//  FlyingPiglet
//
//  Created by Peter Obling on 14/11/2019.
//  Copyright © 2019 Peter Obling. All rights reserved.
// code to tableview made from https://stackoverflow.com/questions/41626348/using-a-uitableview-in-spritekit

// import SwiftUI
import SpriteKit
import UIKit


class GameRoomTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var items: [String] = ["#1 score", "#2 score", "#3 score", "#4 score", "#5 score", "#6 score", "#7 score", "#8 score", "#9 score", "#10 score" ]
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.alpha = 0.5
        return cell
    }
}


class highScene: SKScene {
    var gameTableView = GameRoomTableView()
    private var label : SKLabelNode?
    
    /* UI Connections */
    var backButton1: MSButtonNode!
    
    override func didMove(to view: SKView) {
        
        /* Set UI connections */
        backButton1 = self.childNode(withName: "backButton1") as? MSButtonNode
        
        backButton1.selectedHandler = {
            self.loadBack1()
        }
        
        
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        
        // Table setup
        gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        gameTableView.frame=CGRect(x:50,y:140,width:300,height:440)
        self.scene?.view?.addSubview(gameTableView)
        gameTableView.reloadData()
        
        gameTableView.isScrollEnabled = false;
        
    }
    
    
    func loadBack1() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView? else {
            print("Could not get Skview")
            return
        }
        
        //kode for at fjerne gameTableView fra SuperView,
        //så highscore ikke bliver ved med at blive vist
        gameTableView.removeFromSuperview()
        
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
