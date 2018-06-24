//
//  GameData.swift
//  Memory
//
//  Created by Puja Dialehabady on 30.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation

class GameData {
    
    static var levelsData: LevelsData?
    var levelData: LevelData?
    var matrixIndex = 0 // the matrix index
    
    var delegate : GameDataDelegate?
    var gameOver = false
    var level = 0 // current level
    var life = 0 // current life amount
    var score = 0 // the score
    
    
    var lifeEachLevel = 0 // life to add each level
    var lifeCounter = 0 // decreased each level, counts how many times 'lifeEachLevel' is added before increasing 'lifeEachLevel' by 1 and setting lifeCounter = level
    
    var chainMulti = 0  { // amount of correct cards chained
        didSet {
            if maxChain < chainMulti {
                maxChain = chainMulti
            }
        }
    }
    
    var maxChain = 0
    var upgradeMulti = 1
    
    init() {
        if GameData.levelsData == nil {
            GameData.levelsData = FileUtils.loadLevelData()!
        }
    }
    
    func newGame() {
        level = 0
        life = 1
        score = 0
        lifeEachLevel = 1
        lifeCounter = 1
        chainMulti = 0
        upgradeMulti = 1
        gameOver = false
        levelData = nil
        delegate?.didStartNewGame()
        
    }
    
    func update(level: Int, life: Int, score: Int, chainMulti: Int, lifeEachLevel: Int, lifeCounter: Int) {
        self.level = level
        self.life = life
        self.score = score
        self.chainMulti = chainMulti
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
        if lifeCounter <= 0 && lifeEachLevel < 3{
            lifeEachLevel += 1
            lifeCounter = level == 1 ? 2 : level
        }
        if let levelData = GameData.levelsData!.getLevelData(for: level) {
            self.levelData = levelData
            matrixIndex = levelData.getRandomMatrixIndex()
            delegate?.changedLife(to: life)
            delegate?.changedLevel(to: level)
        } else {
            //TODO: error
        }
        
    }
    
    func updateLife(by amount: Int) {
        guard !gameOver else { return }
        life += amount
        if life <= 0 {
            gameOver = true
        }
        delegate?.changedLife(to: life)
    }
    
    func updateScore(by amount: Int) {
        //guard !gameOver else { return }
        score += amount
        // TODO highscore
        print("update score: from \(score - amount) to: \(score)")
        print(score)
        delegate?.changedScore(to: score)
    }
    
    func getMatrixSize(for levelType: GameScene.LevelType) -> (rows: Int, columns: Int) {
        if levelType == .normal {
            return levelData!.getMatrixSizeAt(index: matrixIndex)
        } else {
            return (rows: 4, columns: 4)
        }
    }
    
    func getMatrix(for levelType: GameScene.LevelType) -> [[Int]] {
        if levelType == .normal {
            return levelData!.matrix[matrixIndex]
        } else {
            return [[1, 1, 1, 1],
                    [1, 1, 1, 1],
                    [1, 1, 1, 1],
                    [1, 1, 1, 1]]
        }
    }
    
    func getCardCount(for levelType: GameScene.LevelType) -> Int {
        if levelType == .normal {
            return levelData!.cards
        } else {
            return 16
        }
    }
}
