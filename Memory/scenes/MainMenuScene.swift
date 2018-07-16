//
//  MainMenuScene.swift
//  Memory
//
//  Created by Puja Dialehabady on 22.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {

    override func didMove(to view: SKView) {
        
        
        
        let bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -10
        self.addChild(bgNode)
        
        let logoView = SKSpriteNode(imageNamed: "Logo")
        logoView.position = CGPoint(x: 0, y: 170)
        logoView.size = CGSize(width: 250, height: 250)
        bgNode.addChild(logoView)
        
        let frameButton = SKSpriteNode(imageNamed: "Rahmen")
        frameButton.size = CGSize(width: 190, height: 120)
        
        let frameButton1 = SKSpriteNode(imageNamed: "Rahmen")
        frameButton1.size = CGSize(width: 190, height: 120)
        
        let frameButton2 = SKSpriteNode(imageNamed: "Rahmen")
        frameButton2.size = CGSize(width: 190, height: 120)
        
        let startButton = ActionNode(color: .black, size: CGSize(width: 180, height: 60))
        //let startLabel = SKLabelNode(text: "Start")
        let startFont = SKSpriteNode(imageNamed: "Start2")
        
        startFont.size = CGSize(width: 80, height: 80)
        startButton.position = CGPoint(x: 0, y: -10)
        
        /*startLabel.fontSize = 35
        startLabel.fontName = "Helvetica Neue Thin"
        startLabel.verticalAlignmentMode = .center
        startButton.addChild(startLabel)*/
        startButton.zPosition = 200
        
        startButton.addChild(frameButton)
        startButton.addChild(startFont)
        self.addChild(startButton)
        
        startButton.action =  {
            let scene = GameScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene, transition: transition)
        }
        
        let bonusButton = ActionNode(color: .black, size: CGSize(width: 180, height: 60))
        let instructionFont = SKSpriteNode(imageNamed: "Instruction2")
        instructionFont.size = CGSize(width: 100, height: 100)
        //let b1Label = SKLabelNode(text: "Anleitung")
        bonusButton.position = CGPoint(x: 0, y: -90)
        /*b1Label.fontSize = 35
        b1Label.fontName = "Helvetica Neue Thin"
        b1Label.verticalAlignmentMode = .center
        bonusButton.addChild(b1Label)*/
        bonusButton.zPosition = 200
        
        let bonus2Button = ActionNode(color: .black, size: CGSize(width: 180, height: 60))
        let settingsFont = SKSpriteNode(imageNamed: "Settings2")
        settingsFont.size = CGSize(width: 80, height: 80)
        //let b2Label = SKLabelNode(text: "Einstellung")
        bonus2Button.position = CGPoint(x: 0, y: -170)
        /*b2Label.fontSize = 35
        b2Label.fontName = "Helvetica Neue Thin"
        b2Label.verticalAlignmentMode = .center
        bonus2Button.addChild(b2Label)*/
        bonus2Button.zPosition = 200
        
        self.addChild(bonusButton)
        self.addChild(bonus2Button)
        bonusButton.addChild(frameButton1)
        bonusButton.addChild(settingsFont)
        bonus2Button.addChild(frameButton2)
        bonus2Button.addChild(instructionFont)
        
        bonusButton.action = {
            let scene = GameScene(size: self.size)
            scene.bonus = 1
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene, transition: transition)
        }
        
        bonus2Button.action = {
            let scene = GameScene(size: self.size)
            scene.bonus = 2
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene, transition: transition)
        }
    }
}
