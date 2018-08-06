//
//  GameData.swift
//  Memory
//
//  Created by Puja Dialehabady on 30.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import os.log

class GameData: NSCoding {
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(level, forKey: PropertyKey.level)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
    
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.level) as? String else {
            os_log("Unable to decode the name for a GameData object.", log: OSLog.default, type: .debug)
            return nil
        }
        let level = aDecoder.decodeInteger(forKey: PropertyKey.level)
        self.init(level: level)
    }
    
    struct PropertyKey {
        static let level = "level"
        static let matrixIndex = "matrixIndex"
        static let gameOver = "gameOver"
        static let life = "life"
        static let score = "score"
        static let lifeEachLevel = "lifeEachLevel"
        static let maxChain = "maxChain"
        static let upgradeMulti = "upgradeMulti"
        static let chainMulti = "chainMulti"
    }
    
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
    
    var maxChain = 0
    var upgradeMulti = 1
    var chainMulti = 0  { // amount of correct cards chained
        didSet {
            if maxChain < chainMulti {
                maxChain = chainMulti
            }
        }
    }
    
    private init(level: Int) {
        
    }
    
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
        } else if levelType == .bonus1 {
            return [[0, 1, 1, 0],
                    [1, 1, 1, 1],
                    [1, 1, 1, 1],
                    [0, 1, 1, 0]]
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
        } else if levelType == .bonus1 {
            return 12
        } else {
            return 16
        }
    }
    
    func getCardData(for levelType: GameScene.LevelType, _ sets: CardSets, _ data: CardsData) -> [CardData]? {
        if levelType == .normal {
            let cardSets = sets.getCardSetsWithDifficulty(levelData!.difficulty)
            let index = Int(arc4random_uniform(UInt32(cardSets.count)))
            print("found sets: \(cardSets.count) index: \(index)")
            let cardSet = cardSets[Int(arc4random_uniform(UInt32(cardSets.count)))]
            var cards = [CardData]()
            for id in cardSet.cards {
                cards.append(data.getCardDataWithId(id))
            }
            return cards
        } else {
            return data.cards
        }
    }
    
    func saveData() {
        
    }
}
