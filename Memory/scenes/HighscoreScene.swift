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

class HighscoreScene: SKScene {
    
    let gameOverText = SKLabelNode(text: "")
    let retryText = SKLabelNode(text: "Spielen")
    let menuText = SKLabelNode(text: "Menü")
    var retryButton: ActionNode!
    var menuButton: ActionNode!
    var background: SKSpriteNode!

    let buttonWidth = 0
    let frameButton1 = SKSpriteNode(imageNamed: "Rahmen2")
    let frameButton2 = SKSpriteNode(imageNamed: "Rahmen2")
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
        logoView.position = CGPoint(x: 0, y: 310)
        logoView.size = CGSize(width: 100, height: 100)
        bgNode.addChild(logoView)
        
        let title = SKLabelNode(text: "Highscore")
        title.lineBreakMode = NSLineBreakMode.byClipping
        title.numberOfLines = 0
        title.preferredMaxLayoutWidth = 400
        title.fontName = "Helvetica Neue Thick"
        title.fontSize = 25
        title.position = CGPoint(x: 0, y: 220)
        
        self.addChild(title)
        
        let retryLabel = SKLabelNode(text: "Spielen")
        retryLabel.verticalAlignmentMode = .center
        retryLabel.fontName = "Helvetica Neue Thick"
        retryLabel.fontSize = 19
        let retryButton = ActionNode(color: .black, size: CGSize(width: retryLabel.frame.width * 1.3, height: retryLabel.frame.height * 2))
        retryButton.position = CGPoint(x: self.size.width/2 - retryButton.size.width/2 - 30, y: self.size.height/2 * -1 + retryButton.size.height + 30)
        
        frameButton2.size = CGSize(width: retryButton.size.width, height: retryButton.size.height)
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

        let menuLabel = SKLabelNode(text: "Hauptmenü")
        menuLabel.fontSize = 19
        menuLabel.verticalAlignmentMode = .center
        menuLabel.fontName = "Helvetica Neue Thick"
        let menuButton = ActionNode(color: .black, size: CGSize(width: menuLabel.frame.width * 1.3, height: menuLabel.frame.height * 2))
        menuButton.position = CGPoint(x: self.size.width/2 * -1 + menuButton.size.width/2 + 30, y: self.size.height/2 * -1 + menuButton.size.height + 30)
        
        frameButton1.size = CGSize(width: menuButton.size.width, height: menuButton.size.height)
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
        menuButton.disable()
        retryButton.disable()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            if let scores = UserDefaults.standard.array(forKey: "game_data_high_score") as? [String] {
                let nameLabel = SKLabelNode(text: "Name")
                nameLabel.verticalAlignmentMode = .center
                nameLabel.horizontalAlignmentMode = .left
                nameLabel.fontName = "Helvetica Neue Thick"
                nameLabel.fontSize = 22
                nameLabel.position = CGPoint(x: -90, y: 180)
                bgNode.addChild(nameLabel)
                
                let scoreLabel = SKLabelNode(text: "Punkte")
                scoreLabel.verticalAlignmentMode = .center
                nameLabel.horizontalAlignmentMode = .right
                scoreLabel.fontName = "Helvetica Neue Thick"
                scoreLabel.fontSize = 22
                scoreLabel.position = CGPoint(x: 120, y: 180)
                bgNode.addChild(scoreLabel)
                
                var count = 0
                print("scores count: \(scores.count)")
                for score in scores.reversed() {
                    print("score: \(score)")
                    var splittedScore = score.split(separator: "@")
                    let scoreName = SKLabelNode(text: String(splittedScore[0]))
                    scoreName.verticalAlignmentMode = .center
                    scoreName.horizontalAlignmentMode = .left
                    scoreName.fontName = "Helvetica Neue Thick"
                    scoreName.fontSize = 20
                    scoreName.position = CGPoint(x: -145, y: 0)
                    let scoreValue = SKLabelNode(text: String(splittedScore[1]))
                    scoreValue.verticalAlignmentMode = .center
                    scoreValue.horizontalAlignmentMode = .right
                    scoreValue.fontName = "Helvetica Neue Thick"
                    scoreValue.fontSize = 20
                    scoreValue.position = CGPoint(x: 145, y: 0)
                    let blackColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha: 0.7)
                    let blackColor2 = UIColor(red:0.00, green:0.00, blue:0.00, alpha: 0.3)
                    let color = count%2 == 0 ? blackColor : blackColor2
                    let row = SKSpriteNode(color: color, size: CGSize(width: 300, height: 50))
                    row.addChild(scoreValue)
                    row.addChild(scoreName)
                    row.position = CGPoint(x: 0, y: 125 - (count * 50))
                    bgNode.addChild(row)
                    count += 1
                }
                
            } else {
                let noScoreLabel = SKLabelNode(text: "Keine Einträge vorhanden :(")
                noScoreLabel.verticalAlignmentMode = .center
                noScoreLabel.horizontalAlignmentMode = .left
                noScoreLabel.fontName = "Helvetica Neue Thick"
                noScoreLabel.fontSize = 22
                noScoreLabel.position = CGPoint(x: 0, y: 170)
                noScoreLabel.addChild(noScoreLabel)
            }
            menuButton.enable()
            retryButton.enable()
        }
    }
}

