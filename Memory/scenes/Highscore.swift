//
//  Highscore.swift
//  Memory
//
//  Created by Niklas Großmann on 07.08.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Highscore: SKScene {
    
    let gameOverText = SKLabelNode(text: "")
    let retryText = SKLabelNode(text: "Spielen")
    let menuText = SKLabelNode(text: "Menü")
    var retryButton: ActionNode!
    var menuButton: ActionNode!
    var background: SKSpriteNode!

    let buttonWidth = 0
    let frameButton1 = SKSpriteNode(imageNamed: "Rahmen")
    let frameButton2 = SKSpriteNode(imageNamed: "Rahmen")
    let gameOverView = SKSpriteNode(imageNamed: "gameover")
    
    let screenSize = UIScreen.main.bounds
    
    let firstLabel = SKLabelNode(text: "1. Deine Mutter    666")
    let secoundLabel = SKLabelNode(text: "2. Dein Vater    555")
    let thirdLabel = SKLabelNode(text: "3. Dei Oma    444")
    let fourthLabel = SKLabelNode(text: "4. THE KING    333")
    let fifthLabel = SKLabelNode(text: "5. asdf    222")
    
    override func didMove(to view: SKView) {
        
        let screenWidth = screenSize.width
        let screenHight = screenSize.height

        let bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -10
        self.addChild(bgNode)
        
        let logoView = SKSpriteNode(imageNamed: "Logo_Teufel")
        logoView.position = CGPoint(x: 0, y: screenHight/2.8)
        logoView.size = CGSize(width: screenWidth/2.75, height: screenWidth/2.75)
        bgNode.addChild(logoView)
        
        let retryButton = ActionNode(color: .black, size: CGSize(width: screenWidth/2.8, height: screenHight/13))
        let retryLabel = SKLabelNode(text: "Spielen")
        retryLabel.verticalAlignmentMode = .center
        retryLabel.fontName = "Helvetica Neue Thick"
        retryButton.position = CGPoint(x: screenWidth/4.4, y: screenHight/(-2.5))
        
        frameButton2.size = CGSize(width: menuText.frame.width * 1.9, height: retryText.frame.height * 4)
        retryLabel.addChild(frameButton2)
        retryButton.addChild(retryLabel)
        self.addChild(retryButton)
        print("\(screenWidth/2) + \(screenHight/(-1.5))")
        
        retryButton.action = {
            let scene = GameScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene, transition: transition)
        }

        let menuButton = ActionNode(color: .black, size: CGSize(width: screenWidth/2.8, height: screenHight/13))
        let menuLabel = SKLabelNode(text: "Menü")
        menuLabel.verticalAlignmentMode = .center
        menuLabel.fontName = "Helvetica Neue Thick"

        menuButton.position = CGPoint(x: screenWidth/(-4.4), y: screenHight/(-2.5))
        
        frameButton1.size = CGSize(width: menuText.frame.width * 1.9, height: retryText.frame.height * 4)
        menuLabel.addChild(frameButton1)
        menuButton.addChild(menuLabel)
        self.addChild(menuButton)
        
        menuButton.action = {
            let scene = MainMenuScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene, transition: transition)
        }
        
        
        
        let namesLabel = SKLabelNode(text: "Name:       Ergebnis:")
        namesLabel.verticalAlignmentMode = .center
        namesLabel.fontName = "Helvetica Neue Thick"
        namesLabel.position = CGPoint(x: 0, y: screenHight/4.5)
        bgNode.addChild(namesLabel)
        

        firstLabel.verticalAlignmentMode = .center
        firstLabel.fontName = "Helvetica Neue Thick"
        firstLabel.position = CGPoint(x: 0, y: screenHight/7)
        bgNode.addChild(firstLabel)
        
        secoundLabel.verticalAlignmentMode = .center
        secoundLabel.fontName = "Helvetica Neue Thick"
        secoundLabel.position = CGPoint(x: 0, y:( screenHight/7 + (-40)))
        bgNode.addChild(secoundLabel)
        
        thirdLabel.verticalAlignmentMode = .center
        thirdLabel.fontName = "Helvetica Neue Thick"
        thirdLabel.position = CGPoint(x: 0, y: ((screenHight/7) + (-80)))
        bgNode.addChild(thirdLabel)
        
        fourthLabel.verticalAlignmentMode = .center
        fourthLabel.fontName = "Helvetica Neue Thick"
        fourthLabel.position = CGPoint(x: 0, y: (screenHight/7) + (-120))
        bgNode.addChild(fourthLabel)
        
        fifthLabel.verticalAlignmentMode = .center
        fifthLabel.fontName = "Helvetica Neue Thick"
        fifthLabel.position = CGPoint(x: 0, y: (screenHight/7) + (-160))
        bgNode.addChild(fifthLabel)
    }
}

