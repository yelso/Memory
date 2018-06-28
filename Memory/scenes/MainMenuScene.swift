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
        
        let startButton = ActionNode(color: .black, size: CGSize(width: 200, height: 60))
        let startLabel = SKLabelNode(text: "Spiel")
        startButton.position = CGPoint(x: 0, y: 0)
        
        startLabel.fontSize = 35
        startLabel.fontName = "Helvetica Neue Thin"
        startLabel.verticalAlignmentMode = .center
        startButton.addChild(startLabel)
        startButton.zPosition = 200
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
        
        let bonusButton = ActionNode(color: .black, size: CGSize(width: 200, height: 60))
        let b1Label = SKLabelNode(text: "Anleitung")
        bonusButton.position = CGPoint(x: 0, y: -80)
        b1Label.fontSize = 35
        b1Label.fontName = "Helvetica Neue Thin"
        b1Label.verticalAlignmentMode = .center
        bonusButton.addChild(b1Label)
        bonusButton.zPosition = 200
        
        let bonus2Button = ActionNode(color: .black, size: CGSize(width: 200, height: 60))
        let b2Label = SKLabelNode(text: "Einstellung")
        bonus2Button.position = CGPoint(x: 0, y: -160)
        b2Label.fontSize = 35
        b2Label.fontName = "Helvetica Neue Thin"
        b2Label.verticalAlignmentMode = .center
        bonus2Button.addChild(b2Label)
        bonus2Button.zPosition = 200
        
        self.addChild(bonusButton)
        self.addChild(bonus2Button)
        
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
