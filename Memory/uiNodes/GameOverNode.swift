//
//  GameOverNode.swift
//  Memory
//
//  Created by Puja Dialehabady on 11.05.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverNode : SKSpriteNode {
    
    
    let origSize: CGSize!
    let gameOverText = SKLabelNode(text: "GAME OVER")
    let retryText = SKLabelNode(text: "Retry")
    let menuText = SKLabelNode(text: "Main Menu")
    var retryButton: ActionNode!
    var menuButton: ActionNode!
    var background: SKSpriteNode!
    let scoreText = SKLabelNode(text: "SCORE")
    let levelText = SKLabelNode(text: "LEVEL")
    let chainText = SKLabelNode(text: "CHAINS")    
    let delegate: GameDelegate
    
    init(_ size: CGSize, _ delegate: GameDelegate) {
        origSize = size
        self.delegate = delegate
        gameOverText.fontName = Constants.scoreFontName
        gameOverText.fontSize = Constants.gameOverTitleFontSize
        gameOverText.fontColor = .white
        gameOverText.verticalAlignmentMode = .center
        if UIDevice.current.userInterfaceIdiom == .phone {
            if origSize.height < 812 {
                print("iphone 8plus")
                gameOverText.position = CGPoint(x: 0, y: origSize.height/2 - (gameOverText.frame.size.height * 2.1))
            } else {
                print("iphone x")
                gameOverText.position = CGPoint(x: 0, y: origSize.height/2 - (gameOverText.frame.size.height * 2.1) - 40) // 40 radius of bezel circle on iphone X
            }
        } else {
            print("ipad")
            gameOverText.position = CGPoint(x: 0, y: origSize.height/2 - (gameOverText.frame.size.height * 2.1))
        }
        
        retryText.fontName = Constants.scoreFontName
        retryText.fontSize = Constants.upgradeFontSize
        retryText.fontColor = .white
        retryText.verticalAlignmentMode = .center
        retryText.horizontalAlignmentMode = .center
        retryButton = ActionNode(color: .orange, size: CGSize(width: retryText.frame.width * 1.2, height: retryText.frame.height * 1.6))
        retryButton.addChild(retryText)
        retryButton.position = CGPoint(x: origSize.width/2 - retryButton.size.width/2 - 30, y: origSize.height/2 * -1 + retryButton.size.height + 40)
        
        
        menuText.fontName = Constants.scoreFontName
        menuText.fontSize = Constants.upgradeFontSize
        menuText.fontColor = .white
        menuText.verticalAlignmentMode = .center
        menuText.horizontalAlignmentMode = .center
        menuButton = ActionNode(color: .orange, size: CGSize(width: menuText.frame.width * 1.2, height: menuText.frame.height * 1.6))
        menuButton.addChild(menuText)
        menuButton.position = CGPoint(x: origSize.width/2 * -1 + menuButton.size.width/2 + 30, y: origSize.height/2 * -1 + menuButton.size.height + 40)
        background = SKSpriteNode(color: .black, size: origSize)
        background.alpha = 0.65
        
        
        scoreText.fontName = Constants.scoreFontName
        scoreText.fontSize = Constants.gameOverTextFontSize
        scoreText.fontColor = .white
        scoreText.verticalAlignmentMode = .bottom
        scoreText.position = CGPoint(x: 0, y: gameOverText.position.y * 0.6)
        
        levelText.fontName = Constants.scoreFontName
        levelText.fontSize = Constants.gameOverTextFontSize
        levelText.fontColor = .white
        levelText.verticalAlignmentMode = .bottom
        levelText.position = CGPoint(x: 0, y: gameOverText.position.y * 0.2)
        
        chainText.fontName = Constants.scoreFontName
        chainText.fontSize = Constants.gameOverTextFontSize
        chainText.fontColor = .white
        chainText.verticalAlignmentMode = .bottom
        chainText.position = CGPoint(x: 0, y: gameOverText.position.y * -0.2)
        
        super.init(texture: nil, color: .clear, size: size)
        self.alpha = 0
        self.position = CGPoint(x: 0, y: 4000)
        
        retryButton.action = {
            self.delegate.newGame()
        }
        
        menuButton.action = {
            if let parent = self.parent as? GameScene {
                if let view = parent.view as! SKView? {
                    let scene = MainMenuScene(size: view.bounds.size)
                    // Set the scale mode to scale to fit the window
                    //scene.scaleMode = .aspectFit
                    scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    // Present the scene
                
                    view.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
                    view.isMultipleTouchEnabled = false
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.ignoresSiblingOrder = false
                }
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showGameOverNode(with data: GameData) {
        self.removeAllChildren()
        gameOverText.setScale(0)
        retryButton.setScale(0)
        menuButton.setScale(0)
        retryText.setScale(0)
        menuText.setScale(0)
        scoreText.setScale(0)
        levelText.setScale(0)
        chainText.setScale(0)
        gameOverText.alpha = 1
        retryButton.alpha = 1
        menuButton.alpha = 1
        retryText.alpha = 1
        menuText.alpha = 1
        scoreText.alpha = 1
        levelText.alpha = 1
        chainText.alpha = 1
        background.alpha = 0.65
        
        self.addChild(background)
        self.addChild(scoreText)
        self.addChild(levelText)
        self.addChild(chainText)
        self.addChild(gameOverText)
        self.addChild(retryButton)
        self.addChild(menuButton)
        self.position = CGPoint(x: 0, y: 0)
        
        let score = createValueLabel(value: "\(data.score)")
        score.position = CGPoint(x: 0, y: scoreText.position.y - 6)
        //let score = SKLabelNode(text: "\(data.score)")
        /*score.fontName = Constants.scoreFontName
        score.fontSize = Constants.gameOverValueFontSize
        score.fontColor = UIColor(red:0.38, green:0.94, blue:0.97, alpha:1.0) //UIColor(red:0.95, green:0.91, blue:0.27, alpha:1.0)
        score.verticalAlignmentMode = .top
        score.position = CGPoint(x: 0, y: scoreText.position.y - 6)
        //score.position = CGPoint(x: 0, y: levelText.position.y +  (scoreText.position.y - levelText.position.y)/2)
        score.addStroke(color: UIColor(red:0.02, green:0.02, blue:0.59, alpha:1.0) /*UIColor(red:0.90, green:0.00, blue:1.00, alpha:1.0)*/, width: 5)
        score.setScale(0) */
        
        let level = createValueLabel(value: "\(data.level)")
        level.position = CGPoint(x: 0, y: levelText.position.y - 6)
        let chains = createValueLabel(value: "\(data.maxChain)")
        if data.maxChain > 1 {
            chains.position = CGPoint(x: 0, y: chainText.position.y - 6)
            self.addChild(chains)
        } else {
            chainText.removeFromParent()
        }
        
        self.addChild(score)
        self.addChild(level)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        fadeIn.timingMode = .easeOut
        self.run(fadeIn)
        
        let plopIn = SKAction.sequence([
                SKAction.scale(to: 1.3, duration: 0.15),
                SKAction.scale(to: 0.7, duration: 0.15),
                SKAction.scale(to: 1.0, duration: 0.1)
            ])
        
        gameOverText.run(afterDelay: 0.15) {
            self.gameOverText.run(plopIn)
        }
        
        scoreText.run(afterDelay: 0.25) {
            self.scoreText.run(plopIn)
        }
        
        score.run(afterDelay: 0.3) {
            score.run(plopIn)
        }
        
        levelText.run(afterDelay: 0.35) {
            self.levelText.run(plopIn)
        }
        
        level.run(afterDelay: 0.4) {
            level.run(plopIn)
        }
        
        chainText.run(afterDelay: 0.45) {
            self.chainText.run(plopIn)
        }
        
        chains.run(afterDelay: 0.5) {
            chains.run(plopIn)
        }
        
        retryButton.run(afterDelay: 0.65) {
            self.retryButton.run(plopIn)
        }
        menuButton.run(afterDelay: 0.65) {
            self.menuButton.run(plopIn)
        }
        retryText.run(afterDelay: 0.7) {
            self.retryText.run(plopIn)
        }
        menuText.run(afterDelay: 0.7) {
            self.menuText.run(plopIn)
        }
    }
    
    func createValueLabel(value: String) -> SKLabelNode {
        let valueLabel = SKLabelNode(text: value)
        valueLabel.fontName = Constants.scoreFontName
        valueLabel.fontSize = Constants.gameOverValueFontSize
        valueLabel.fontColor = UIColor(red:0.38, green:0.94, blue:0.97, alpha:1.0)
        valueLabel.verticalAlignmentMode = .top
        valueLabel.addStroke(color: UIColor(red:0.02, green:0.02, blue:0.59, alpha:1.0) , width: 5)
        valueLabel.setScale(0)
        return valueLabel
    }
    
    func hide() {
        self.children.forEach { (node) in
            node.run(SKAction.fadeOut(withDuration: 0.25))
        }
        self.run(afterDelay: 0.3) {
            self.removeAllChildren()
            self.position = CGPoint(x: 0, y: 5000)
        }
    }
}
