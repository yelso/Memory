//
//  GameOverNode.swift
//  Memory
//
//  Created by Puja Dialehabady on 11.05.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverNode : SKSpriteNode, UITextFieldDelegate {
    
    
    let origSize: CGSize!
    let gameOverText = SKLabelNode(text: "")
    let retryText = SKLabelNode(text: "Spielen")
    let menuText = SKLabelNode(text: "Hauptmenü")
    let saveText = SKLabelNode(text: "Ergebnis speichern")
    var retryButton: ActionNode!
    var saveScoreButton: ActionNode!
    var menuButton: ActionNode!
    var background: SKSpriteNode!
    let scoreText = SKLabelNode(text: "punkte")
    let levelText = SKLabelNode(text: "level")
    let chainText = SKLabelNode(text: "multi")
    let delegate: GameDelegate
    let inputScoreText = SKLabelNode(text: "Name hier eingeben")
    var scoreName = ""
    let buttonWidth = 0
    let frameButton1 = SKSpriteNode(imageNamed: "Rahmen2")
    let frameButton2 = SKSpriteNode(imageNamed: "Rahmen2")
    let frameButton3 = SKSpriteNode(imageNamed: "Rahmen2")
    let gameOverView = SKSpriteNode(imageNamed: "gameover")
    var data: Game?
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        return (text.count + string.count) <= 10
    }
    
    init(_ size: CGSize, _ delegate: GameDelegate) {
        origSize = size
        self.delegate = delegate
        gameOverText.fontName = Constants.gameOverFontName
        gameOverText.fontSize = Constants.gameOverTitleFontSize
        gameOverText.fontColor = .white
        gameOverText.verticalAlignmentMode = .center
        if UIDevice.current.userInterfaceIdiom == .phone {
            if origSize.height < 812 {
                gameOverText.position = CGPoint(x: 0, y: origSize.height/2 - (gameOverText.frame.size.height * 2.1))
            } else {
                gameOverText.position = CGPoint(x: 0, y: origSize.height/2 - (gameOverText.frame.size.height * 2.1) - 40) // 40 radius of bezel circle on iphone X
            }
        } else {
            gameOverText.position = CGPoint(x: 0, y: origSize.height/2 - (gameOverText.frame.size.height * 2.1))
        }
        
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            if origSize.height < 812 {
//                gameOverView.position = CGPoint(x: 0, y: origSize.height/2 - (gameOverView.frame.size.height * 2.1))
//            } else {
//                gameOverView.position = CGPoint(x: 0, y: origSize.height/2 - (gameOverView.frame.size.height * 2.1) - 40) // 40 radius of bezel circle on iphone X
//            }
//        } else {
//            gameOverView.position = CGPoint(x: 0, y: origSize.height/2 - (gameOverView.frame.size.height * 2.1))
//        }
        gameOverView.position = CGPoint(x: 0, y: origSize.height/2 - (gameOverView.frame.size.height * 2.5) + 40 )
        //x=390 y=120
        gameOverView.size = CGSize(width: origSize.width * 0.85,height: origSize.height * (100/(origSize.height)))

        
        retryText.fontName = "Helvetica Neue Thick"
        retryText.fontSize = Constants.upgradeFontSize
        retryText.fontColor = .white
        retryText.verticalAlignmentMode = .center
        retryText.horizontalAlignmentMode = .center
        retryButton = ActionNode(color: .black, size: CGSize(width: retryText.frame.width * 1.3, height: retryText.frame.height * 2))
        frameButton1.size = CGSize(width: retryButton.size.width, height: retryButton.size.height)
        retryText.addChild(frameButton1)
        retryButton.addChild(retryText)
        retryButton.position = CGPoint(x: origSize.width/2 - retryButton.size.width/2 - 30, y: origSize.height/2 * -1 + retryButton.size.height + 30)
        
        saveText.fontName = "Helvetica Neue Thick"
        saveText.fontSize = Constants.upgradeFontSize
        saveText.fontColor = .white
        saveText.verticalAlignmentMode = .center
        saveText.horizontalAlignmentMode = .center
        
        saveScoreButton = ActionNode(color: .black, size: CGSize(width: saveText.frame.width * 1.3, height: retryText.frame.height * 2.1))
        frameButton2.size = CGSize(width: saveScoreButton.size.width, height: saveScoreButton.size.height)
        saveText.addChild(frameButton2)
        saveScoreButton.addChild(saveText)
        saveScoreButton.position = CGPoint(x: 0, y: origSize.height/2 * -1 + saveScoreButton.size.height + 110)
        
        menuText.fontName = "Helvetica Neue Thick"
        menuText.fontSize = Constants.upgradeFontSize
        menuText.fontColor = .white
        menuText.verticalAlignmentMode = .center
        menuText.horizontalAlignmentMode = .center
        
        
        menuButton = ActionNode(color: .black, size: CGSize(width: menuText.frame.width * 1.2, height: retryText.frame.height * 2))
        menuButton.addChild(menuText)
        menuButton.position = CGPoint(x: origSize.width/2 * -1 + menuButton.size.width/2 + 30, y: origSize.height/2 * -1 + menuButton.size.height + 30)
        frameButton3.size = CGSize(width: menuButton.size.width, height: menuButton.size.height)
        menuText.addChild(frameButton3)
        background = SKSpriteNode(color: .black, size: origSize)
        background.alpha = 0.65

        scoreText.fontName = Constants.gameOverFontName
        scoreText.fontSize = Constants.gameOverTextFontSize
        scoreText.fontColor = .white
        scoreText.verticalAlignmentMode = .bottom
        scoreText.position = CGPoint(x: 0, y: gameOverText.position.y * 0.45)
        
        levelText.fontName = Constants.gameOverFontName
        levelText.fontSize = Constants.gameOverTextFontSize
        levelText.fontColor = .white
        levelText.verticalAlignmentMode = .bottom
        levelText.position = CGPoint(x: 0, y: gameOverText.position.y * 0.05)
        
        chainText.fontName = Constants.gameOverFontName
        chainText.fontSize = Constants.gameOverTextFontSize
        chainText.fontColor = .white
        chainText.verticalAlignmentMode = .bottom
        chainText.position = CGPoint(x: 0, y: gameOverText.position.y * -0.35)
        
        super.init(texture: nil, color: .clear, size: size)
        self.alpha = 0
        self.position = CGPoint(x: 0, y: 4000)
        
        retryButton.action = {
            self.delegate.startNewGame()
        }
        
        menuButton.action = {
            if let parent = self.parent as? GameScene {
                if let view = parent.view {
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
        
        saveScoreButton.action = {
            let alertController = self.createAlert(for: self.saveScoreButton)
            DispatchQueue.main.async {
                self.scene?.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
            //self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            //alertController.textFields?[0].text = ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createAlert(for cell: ActionNode) -> UIAlertController {
        let alertController = UIAlertController(title: "Name eingeben", message: "Gib deinen Namen ein.\n", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.keyboardAppearance = .dark
        
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            if (alertController.textFields?[0].text?.isEmpty)! || (alertController.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                HapticFeedback.error()
                self.shake()
            } else {
                self.scoreName = (alertController.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines))!
                self.saveScoreButton.disable()
                DispatchQueue.main.async {
                    self.data?.saveScore(self.scoreName, (self.data?.score)!)
                }
                if let parent = self.parent as? GameScene {
                    if let view = parent.view {
                        let scene = HighscoreScene(size: view.bounds.size)
                        // Set the scale mode to scale to fit the window
                        //scene.scaleMode = .aspectFit
                        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        // Present the scene
                        view.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
                        view.isMultipleTouchEnabled = false
                        view.ignoresSiblingOrder = false
                    }
                }
            }
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    func showGameOverNode(with data: Game) {
        self.data = data
        self.saveScoreButton.enable()
        self.removeAllChildren()
        gameOverView.setScale(0)
        retryButton.setScale(0)
        menuButton.setScale(0)
        retryText.setScale(0)
        menuText.setScale(0)
        scoreText.setScale(0)
        levelText.setScale(0)
        chainText.setScale(0)
        saveText.setScale(0)
        saveScoreButton.setScale(0)
        gameOverView.alpha = 1
        retryButton.alpha = 1
        menuButton.alpha = 1
        saveScoreButton.alpha = 1
        retryText.alpha = 1
        menuText.alpha = 1
        scoreText.alpha = 1
        levelText.alpha = 1
        chainText.alpha = 1
        saveText.alpha = 1
        background.alpha = 0.65
        
        self.addChild(background)
        self.addChild(scoreText)
        self.addChild(levelText)
        self.addChild(chainText)
        self.addChild(retryButton)
        self.addChild(menuButton)
        self.addChild(saveScoreButton)
        self.addChild(gameOverView)

        self.position = CGPoint(x: 0, y: 0)
        
        let score = createValueLabel(value: "\(data.score)", UIColor(red:1.00, green:0.65, blue:0.00, alpha:1.0))
        score.position = CGPoint(x: 0, y: scoreText.position.y - 6)
        
        // MARK: TODO
        if(true){
            
        }
        
        
        
        let level = createValueLabel(value: "\(data.level)", UIColor(red:0.00, green:0.73, blue:1.00, alpha:1.0))
        level.position = CGPoint(x: 0, y: levelText.position.y - 6)
        let chains = createValueLabel(value: "\(data.maxChain)", UIColor(red:1.00, green:0.00, blue:0.54, alpha:1.0), "x")
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
        
        gameOverView.run(afterDelay: 0.15) {
            self.gameOverView.run(plopIn)
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
        
        retryButton.run(afterDelay: 0.6) {
            self.retryButton.run(plopIn)
        }
        menuButton.run(afterDelay: 0.6) {
            self.menuButton.run(plopIn)
        }
        saveScoreButton.run(afterDelay: 0.6) {
            self.saveScoreButton.run(plopIn)
        }
        retryText.run(afterDelay: 0.65) {
            self.retryText.run(plopIn)
        }
        menuText.run(afterDelay: 0.65) {
            self.menuText.run(plopIn)
        }
        saveText.run(afterDelay: 0.65) {
            self.saveText.run(plopIn)
        }
    }
    
    func createValueLabel(value: String, _ color: UIColor, _ suffix: String = "") -> SKLabelNode {
        let valueLabel = SKLabelNode(text: "\(suffix)\(value)")
        valueLabel.fontName = Constants.gameOverFontName
        valueLabel.fontSize = Constants.gameOverValueFontSize
        valueLabel.fontColor = color //UIColor(red:1.00, green:0.65, blue:0.00, alpha: 1.0) //UIColor(red:0.38, green:0.94, blue:0.97, alpha:1.0)
        valueLabel.verticalAlignmentMode = .top
        //valueLabel.addStroke(color: UIColor(red:0.02, green:0.02, blue:0.59, alpha:1.0) , width: 5)
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
