//
//  GameData.swift
//  Memory
//
//  Created by Puja Dialehabady on 30.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation

class GameData {
    
    var delegate : GameDataDelegate?
    
    var gameOver = false
    var level = 0 // current level
    var life = 0 // current life amount
    var score = 0 // the score
    
    var chain = 0 // amount of correct cards chained
    
    var lifeEachLevel = 0 // life to add each level
    var lifeCounter = 0 // decreased each level, counts how many times 'lifeEachLevel' is added before increasing 'lifeEachLevel' by 1 and setting lifeCounter = level
    
    var multi = 0
    
    func newGame() {
        level = 0
        life = 0
        score = 0
        chain = 0
        lifeEachLevel = 1
        lifeCounter = 1
        multi = 0
        gameOver = false
        delegate?.didStartNewGame()
    }
    
    func update(level: Int, life: Int, score: Int, chain: Int, lifeEachLevel: Int, lifeCounter: Int) {
        self.level = level
        self.life = life
        self.score = score
        self.chain = chain
        self.lifeEachLevel = lifeEachLevel
        self.lifeCounter = lifeCounter
        if delegate != nil {
            delegate?.changedLevel(to: level)
            delegate?.changedScore(to: score)
            delegate?.changedLife(to: life)
        }
    }
    
    func nextLevel() {
        level += 1
        life += lifeEachLevel
        lifeCounter -= 1
        if lifeCounter <= 0 {
            lifeEachLevel += 1
            lifeCounter = level == 1 ? 2 : level
        }
        delegate?.changedLife(to: life)
        delegate?.changedLevel(to: level)
    }
    
    func updateLife(by amount: Int) {
        guard !gameOver else { return }
        life += amount
        if life < 0 {
            gameOver = true
        }
        delegate?.changedLife(to: life)
    }
    
    func updateScore(by amount: Int) {
        //guard !gameOver else { return }
        score += amount
        // TODO highscore
        print(score)
        delegate?.changedScore(to: score)
    }
}
