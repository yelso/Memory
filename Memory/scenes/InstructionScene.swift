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
        logoView.position = CGPoint(x: 0, y: 310)
        logoView.size = CGSize(width: 100, height: 100)
        bgNode.addChild(logoView)
        
        let textLabel = SKLabelNode(text: "Anleitung")
        textLabel.lineBreakMode = NSLineBreakMode.byClipping
        textLabel.numberOfLines = 0
        textLabel.preferredMaxLayoutWidth = 400
        textLabel.fontName = "Helvetica Neue Thick"
        textLabel.fontSize = 24
        textLabel.position = CGPoint(x: 0, y: 220)
        
        self.addChild(textLabel)
        let groundButton = ActionNode(color: .black, size: CGSize(width: 300, height: 380))
        groundButton.position = CGPoint(x: 0, y: 0)
        let text = SKLabelNode(text: "ANLEITUNG")
        text.text = "Evil Twin ist ein klassisches Memoryspiel für iPhone. Ziel des Spiel ist es Bilderpaare zu finden.\n\nBonuslevel:\nEs gibt zwei Arten von Bonusleveln. \n1. Decke die vorgegebene Zahlenreihenfolge auf \n2. Finde die Buchstaben 'U''L''M'.\nFinde anschließend Bilderpaare um noch mehr Punkte zu sammeln.\n\nVIEL SPASS"
        text.lineBreakMode = NSLineBreakMode.byClipping
        text.numberOfLines = 0
        text.preferredMaxLayoutWidth = 255
        text.fontName = "Helvetica Neue Thin"
        text.fontSize = 18
        text.position = CGPoint(x: 0, y: -168)
        let frame = SKSpriteNode(imageNamed: "Rahmen2")
        frame.size = CGSize(width: 300, height: 385)
        groundButton.addChild(frame)
        
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
        
        let frameButton = SKSpriteNode(imageNamed: "Rahmen2")
        frameButton.size = CGSize(width: 120, height: 40)
        
        let gameButton = ActionNode(color: .black, size: CGSize(width: 120, height: 40))
        let gameLabel = SKLabelNode(text: "Start")
        gameLabel.verticalAlignmentMode = .center
        gameLabel.fontName = "Helvetica Neue Thick"
        gameLabel.fontSize = 19
        
        gameButton.position = CGPoint(x: 0, y: -260)
     
    
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
            
        //_Button_Back
        let buttonBack = ActionNode(color: .black, size: CGSize(width: 120, height: 40))
        buttonBack.position = CGPoint(x: 0, y: -320)
        let labelButton = SKLabelNode(text: "Zurück")
        labelButton.verticalAlignmentMode = .center
        labelButton.fontName = "Helvetica Neue Thick"
        labelButton.fontSize = 19
        buttonBack.addChild(labelButton)
        self.addChild(buttonBack)
        
        //_Frame_BB
        let frameButtonBack = SKSpriteNode(imageNamed: "Rahmen2")
        frameButtonBack.size = CGSize(width: 120, height: 40)
        buttonBack.addChild(frameButtonBack)
        
        
        buttonBack.action =  {
            let scene = MainMenuScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene, transition: transition)
        }
        
    }
        
    
    
}

