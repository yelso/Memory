//
//  Introduction.swift
//  Memory
//
//  Created by Linda Schrödl on 06.08.18.
//  Copyright © 2018 puja. All rights reserved.
//

import SpriteKit
import GameplayKit

class InstructionScene: SKScene {
    
    override func didMove(to view: SKView) {
        let image = UserDefaults.standard.string(forKey: "background")
        let bgNode = SKSpriteNode(imageNamed: image!)
        bgNode.zPosition = -10
        self.addChild(bgNode)
        
        let logoView = SKSpriteNode(imageNamed: "Logo_Teufel")
        logoView.position = CGPoint(x: 0, y: 250)
        logoView.size = CGSize(width: 150, height: 150)
        bgNode.addChild(logoView)
        
        let groundButton = ActionNode(color: .black, size: CGSize(width: 250, height: 365))
        groundButton.position = CGPoint(x: 0, y: -20)
        let text = SKLabelNode(text: "ANLEITUNG")
        text.text = "ANLEITUNG\n\nEvil Twin ist ein klassisches Memoryspiel für iPhone. Ziel des Spiel ist es Bilderpaare zu finden.\n\nBonuslevel:\nEs gibt zwei Arten von Bonusleveln. \n1. Decke die vorgegebene Zahlenreihenfolge auf \n2. Finde die Buchstaben 'U''L''M'.\nFinde anschliessend Bilderpaare um noch mehr Punkte zu holen.\n\nVIEL SPASS"
        text.lineBreakMode = NSLineBreakMode.byClipping
        text.numberOfLines = 0
        text.preferredMaxLayoutWidth = 230
        text.fontName = "Helvetica Neue Thin"
        text.fontSize = 17
        text.position = CGPoint(x: 0, y: -180)
        
        self.addChild(groundButton)
        groundButton.addChild(text)
        
        groundButton.action =  {
            let scene = MainMenuScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene, transition: transition)
        }
        
        let frameButton = SKSpriteNode(imageNamed: "Rahmen")
        frameButton.size = CGSize(width: 155, height:  130)
        
        let gameButton = ActionNode(color: .black, size: CGSize(width: 150, height: 60))
       let gameLabel = SKLabelNode(text: "Start")
        gameLabel.verticalAlignmentMode = .center
        gameLabel.fontName = "Helvetica Neue Thick"
        
        gameButton.position = CGPoint(x: 0, y: -250)
     
    
        gameLabel.addChild(frameButton)
        gameButton.addChild(gameLabel)
        self.addChild(gameButton)
        
       gameButton.action = {
            let scene = GameScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene, transition: transition)
        }
            
        
        
    }
        
    
    
}

