//
//  Hud.swift
//  Memory
//
//  Created by Puja Dialehabady on 30.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import SpriteKit

class Hud : SKSpriteNode, HudDelegate {
    
    var score: Int = 0
    var scoreLabel = SKLabelNode(text: "0")
    var timer : Timer?
    
    var level: Int = 0
    var levelLabel = SKLabelNode(text: "Level 0")
    var heartImg = SKSpriteNode(texture: SKTexture(imageNamed: "heart_2"))
    
    var life: Int = 0
    var lifeLabel = SKLabelNode(text: "0")
    let particles = SKEmitterNode(fileNamed: "LevelUpParticle")
    
    var bonusTitle = SKLabelNode(text: "Bonus")
    var bonusExplanation = SKLabelNode()
    
    var bonusCardsToSelect = [SKSpriteNode]()
    var nextCardIndex = 0
    init(_ sceneSize: CGSize) {
        super.init(texture: nil, color: .clear, size: CGSize(width: sceneSize.width, height: Constants.hudHeight))
        if UIDevice.current.userInterfaceIdiom == .phone {
            if sceneSize.height < 812 {
                print("iphone 8plus")
                self.position = CGPoint(x: 0, y: sceneSize.height/2 - Constants.hudHeight/2)
            } else {
                print("iphone x")
                self.position = CGPoint(x: 0, y: sceneSize.height/2 - Constants.hudHeight/2 - 40) // 40 radius of bezel circle on iphone X
            }
        } else {
            print("ipad")
            self.position = CGPoint(x: 0, y: sceneSize.height/2 - Constants.hudHeight/2)
        }
        print("my pos: \(self.position)")
        heartImg.position = CGPoint(x: self.size.width/2 - heartImg.size.width/2, y: 0)
        
        let scoreText = SKLabelNode(text: "Punkte:")
        scoreText.position = CGPoint(x: -1 * self.size.width/2 + 17, y: 0)
        scoreText.fontSize = Constants.hudFontSize
        scoreText.verticalAlignmentMode = .center
        scoreText.horizontalAlignmentMode = .left
        scoreText.fontColor = .yellow
        scoreText.fontName = Constants.scoreFontName
        
        scoreLabel.position = CGPoint(x:scoreText.position.x + scoreText.frame.width + 10, y: 0)
        scoreLabel.fontSize = Constants.hudFontSize
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontColor = .yellow
        scoreLabel.fontName = Constants.scoreFontName
        
        levelLabel.fontSize = Constants.hudFontSize
        levelLabel.verticalAlignmentMode = .center
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.fontColor = .white
        levelLabel.fontName = Constants.scoreFontName
        
        lifeLabel.position = CGPoint(x: self.size.width/2 - heartImg.size.width, y: 0)
        lifeLabel.fontSize = Constants.hudFontSize
        lifeLabel.verticalAlignmentMode = .center
        lifeLabel.horizontalAlignmentMode = .right
        lifeLabel.fontColor = .red
        lifeLabel.fontName = Constants.scoreFontName
        
        bonusTitle.fontSize = Constants.hudBonusFontSize
        bonusExplanation.fontSize = Constants.hudBonusExplanationFontSize
        bonusTitle.fontName = Constants.scoreFontName
        bonusExplanation.fontName = Constants.scoreFontName
        bonusTitle.color = .white
        bonusExplanation.color = .white
        bonusTitle.verticalAlignmentMode = .center
        bonusExplanation.verticalAlignmentMode = .center
        bonusTitle.horizontalAlignmentMode = .center
        bonusExplanation.horizontalAlignmentMode = .center
        bonusTitle.position = CGPoint(x: 0, y: -47)
        bonusExplanation.position = CGPoint(x: 0, y: -87)
        bonusTitle.alpha = 0
        bonusExplanation.alpha = 0
        
        self.addChild(heartImg)
        self.addChild(scoreText)
        self.addChild(scoreLabel)
        self.addChild(levelLabel)
        self.addChild(lifeLabel)
        self.addChild(bonusTitle)
        self.addChild(bonusExplanation)
        
        particles!.position = levelLabel.position
        particles!.particlePositionRange = CGVector(dx: levelLabel.frame.width, dy: levelLabel.frame.height)
        particles!.zPosition = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func changedLife(to life: Int) {
        if life < self.life {
            animateHeartBreak()
        }
        self.life = life
        updateLifeLabel()
    }
    
    func changedScore(to score: Int) {
        //self.score = score
        animateScore(to: score)
        //updateScoreLabel()
    }
    
    func changedLevel(to level: Int) {
        let oldLevel = self.level
        self.level = level
        updateLevelLabel(animated: oldLevel < self.level)
    }
    
    func didStartNewGame() {
        print("new game")
        timer?.invalidate()
        life = 0
        score = 0
        endNumber = 0
        level = 0
        updateLevelLabel(animated: false)
        updateLifeLabel()
        updateScoreLabel()
    }

    func didLoadGameData() {
        
    }
    
    func updateScoreLabel() {
        print("score set to \(score)")
        scoreLabel.text = "\(Int(endNumber))"
    }
    
    func updateLevelLabel(animated: Bool) {
        if animated {
            let copy = particles!.copy() as! SKEmitterNode
            self.addChild(copy)
            copy.run(SKAction.afterDelay(1, runBlock: {
                copy.removeFromParent()
            }))
            
            levelLabel.text = "Level \(level)"
        } else {
            levelLabel.text = "Level \(level)"
        }
    }
    
    func updateLifeLabel() {
        lifeLabel.text = "\(life < 0 ? 0 : life)"
    }
    
    func animateHeartBreak() {
       /* let f0 = SKTexture.init(imageNamed: "heartbreak1")
        let f1 = SKTexture.init(imageNamed: "heartbreak2")
        let f2 = SKTexture.init(imageNamed: "heartbreak3")
        let f3 = SKTexture.init(imageNamed: "heartbreak4")
        let f4 = SKTexture.init(imageNamed: "heartbreak5")
        let f5 = SKTexture.init(imageNamed: "heartbreak6")
        let f6 = SKTexture.init(imageNamed: "heartbreak7") */
        var frames = [SKTexture]()
        for index in 1..<15 {
            frames.append(SKTexture(imageNamed: "heartbreak_2_\(index)"))
        }
        // Load the first frame as initialization
        let heartbreak = SKSpriteNode(imageNamed: "heart_2")
        
        // Change the frame per 0.2 sec
        let animation = SKAction.animate(with: frames, timePerFrame: 0.04)
        let group = SKAction.group([animation, SKAction.fadeAlpha(to: 0.4, duration: 0.56)])
        heartbreak.run(SKAction.sequence([group, SKAction.run {
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.13)
            scaleUp.timingMode = .easeIn
            self.heartImg.run(scaleUp)
            heartbreak.run(SKAction.group([
                SKAction.moveBy(x: 0, y: -20, duration: 0.4),
                SKAction.fadeOut(withDuration: 0.4)
                ]))
            heartbreak.run(afterDelay: 1.0, {
                heartbreak.removeFromParent()
            })
            }]))
        heartbreak.position = heartImg.position
        self.addChild(heartbreak)
        heartImg.setScale(0)
    }
    
    var progress: TimeInterval = 0
    var duration: TimeInterval = 1.5
    var lastUpdate: TimeInterval = Date.timeIntervalSinceReferenceDate
    var startNumber: Float = 0
    var endNumber: Float = 0
    
    var currentCounterValue: Float {
        if progress >= duration {
            //score = Int(ceil(endNumber))
            return endNumber
        }
        
        let percentage = Float(progress / duration)
        let update = updateCounter(counterValue: percentage)
        let value = startNumber + (update * (endNumber - startNumber))
        //score = Int(ceil(value))
        return value
        
    }
    func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        if progress >= duration {
            invalidateTimer()
            progress = duration
        }
        updateText(value: currentCounterValue)
    }
    
    func updateText(value: Float) {
        scoreLabel.text = "\(Int(ceil(value)))" //Int(value) +
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func animateScore(to value: Int) {
        lastUpdate = Date.timeIntervalSinceReferenceDate
        progress = 0
        startNumber = endNumber
        endNumber = Float(value)
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (t) in
            self.updateValue()
        })
    }
    
    func updateCounter(counterValue: Float) -> Float {
        return 1.0 - pow(1 - counterValue, 3)
    }
    
    func displayBonus(for levelType: Game.LevelType) {
        bonusTitle.run(SKAction.fadeIn(withDuration: 0.5))
        if levelType == .bonus2 {
            bonusExplanation.text = "Wähle die Karten in der Reihenfolge aus!"
            bonusExplanation.run(SKAction.fadeIn(withDuration: 0.5))
        }
    }
    
    func hideBonus() {
        bonusTitle.run(SKAction.fadeOut(withDuration: 0.5))
        bonusExplanation.run(SKAction.fadeOut(withDuration: 0.5))
    }

    func selectNextCard() {
        bonusCardsToSelect[nextCardIndex].alpha = 1.0
        nextCardIndex = nextCardIndex + 1
        
    }
}
