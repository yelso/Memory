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
        let image = UserDefaults.standard.string(forKey: "background")
        let bgNode = SKSpriteNode(imageNamed: image!)
        bgNode.zPosition = -10
        self.addChild(bgNode)
        
        let logoView = SKSpriteNode(imageNamed: "Logo_Teufel")
        logoView.position = CGPoint(x: 0, y: 155)
        logoView.size = CGSize(width: 250, height: 250)
        bgNode.addChild(logoView)
        
        let frameButton = SKSpriteNode(imageNamed: "Rahmen2")
        frameButton.size = CGSize(width: 180, height: 60)
        
        let frameButton1 = SKSpriteNode(imageNamed: "Rahmen2")
        frameButton1.size = CGSize(width: 180, height: 60)
        
        let frameButton2 = SKSpriteNode(imageNamed: "Rahmen2")
        frameButton2.size = CGSize(width: 180, height: 60)
        
        let startButton = ActionNode(color: .black, size: CGSize(width: 180, height: 60))
        let startLabel = SKLabelNode(text: "Start")
        startLabel.verticalAlignmentMode = .center
        startLabel.fontName = "Helvetica Neue Thick"
        startButton.position = CGPoint(x: 0, y: -40)
        startButton.zPosition = 200
        
        startButton.addChild(frameButton)
        startButton.addChild(startLabel)
        self.addChild(startButton)
        
        startButton.action =  {
            let scene = GameScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.presentScene(scene, transition: transition)
        }
        
        let bonusButton = ActionNode(color: .black, size: CGSize(width: 180, height: 60))
        let b1Label = SKLabelNode(text: "Anleitung")
        bonusButton.position = CGPoint(x: 0, y: -200)
        b1Label.fontName = "Helvetica Neue Thick"
        b1Label.verticalAlignmentMode = .center
        bonusButton.addChild(b1Label)
        bonusButton.zPosition = 200
        
        let bonus2Button = ActionNode(color: .black, size: CGSize(width: 180, height: 60))
        let b2Label = SKLabelNode(text: "Einstellung")
        bonus2Button.position = CGPoint(x: 0, y: -280)
        b2Label.fontName = "Helvetica Neue Thick"
        b2Label.verticalAlignmentMode = .center
        bonus2Button.addChild(b2Label)
        bonus2Button.zPosition = 200
        
        self.addChild(bonusButton)
        self.addChild(bonus2Button)
        bonusButton.addChild(frameButton1)
        bonus2Button.addChild(frameButton2)
        
        bonusButton.action = {
            let scene = InstructionScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.presentScene(scene, transition: transition)
        }
        
        bonus2Button.action = {
            let scene = SettingsScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.presentScene(scene, transition: transition)
        }
        
        let bonus3Button = ActionNode(color: .black, size: CGSize(width: 180, height: 60))
        let b3Label = SKLabelNode(text: "Highscore")
        bonus3Button.position = CGPoint(x: 0, y: -120)
        b3Label.fontName = "Helvetica Neue Thick"
        b3Label.verticalAlignmentMode = .center
        bonus3Button.addChild(b3Label)
        bonus3Button.zPosition = 200
        self.addChild(bonus3Button)
        let frameButton3 = SKSpriteNode(imageNamed: "Rahmen2")
        frameButton3.size = CGSize(width: 180, height: 60)
        bonus3Button.addChild(frameButton3)
        
        bonus3Button.action = {
            let scene = HighscoreScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.presentScene(scene, transition: transition)
        }
    }
}
