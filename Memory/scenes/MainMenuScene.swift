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
        let startButton = ActionNode(color: .orange, size: CGSize(width: 120, height: 60))
        let startLabel = SKLabelNode(text: "Start")
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
            let transition = SKTransition.push(with: .left, duration: 0.5)
            view.isMultipleTouchEnabled = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene, transition: SKTransition.doorway(withDuration: 1))
        }
    }
}
