//
//  GameData.swift
//  Memory
//
//  Created by Puja Dialehabady on 30.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import os.log

class Game {
    
    static var levelsData: LevelsData?
    enum LevelType {
        case normal
        case bonus1
        case bonus2
    }
    
    var levelType = LevelType.normal
    var levelData: LevelData?
    var matrixIndex = 0 // the matrix index
    
    var hudDelegate : HudDelegate?
    var gameDelegate : GameDelegate?
    var gameOver = false
    var level = 0 // current level
    var life = 0 // current life amount
    var score = 0 // the score
    var matrix = [[Int]] ()
    var remainingCards = 0
    
    var lifeEachLevel = 0 // life to add each level
    var lifeCounter = 0 // decreased each level, counts how many times 'lifeEachLevel' is added before increasing 'lifeEachLevel' by 1 and setting lifeCounter = level
    
    var maxChain = 0
    var upgradeMulti = 1
    var chainMulti = 0  { // amount of correct cards chained
        didSet {
            if maxChain < chainMulti {
                maxChain = chainMulti
                saveMaxChain()
            }
            saveChainMulti()
        }
    }
    
    init() {
        if Game.levelsData == nil {
            Game.levelsData = FileUtils.loadLevelData()!
        }
    }
    
    func newGame() {
        level = 0
        life = 1
        score = 0
        lifeEachLevel = 1
        lifeCounter = 0
        chainMulti = 0
        upgradeMulti = 1
        gameOver = false
        levelData = nil
        hudDelegate?.didStartNewGame()
        invalidateData()
    }
    
    func update(level: Int, life: Int, score: Int, chainMulti: Int, lifeEachLevel: Int, lifeCounter: Int) {
        self.level = level
        self.life = life
        self.score = score
        self.chainMulti = chainMulti
        self.lifeEachLevel = lifeEachLevel
        self.lifeCounter = lifeCounter
        if hudDelegate != nil {
            hudDelegate?.changedLevel(to: level)
            hudDelegate?.changedScore(to: score)
            hudDelegate?.changedLife(to: life)
        }
    }
    
    func nextLevel() {
        level += 1
        life += lifeEachLevel
        print("updating life from \(life-lifeEachLevel) to \(life):")
        if lifeCounter > 0 {
            lifeCounter -= 1
        } else if lifeCounter <= 0 && lifeEachLevel <= 3{
            lifeEachLevel += 1
            lifeCounter = level == 1 ? 2 : level
        }
        if let levelData = Game.levelsData!.getLevelData(for: level) {
            self.levelData = levelData
            matrixIndex = levelData.getRandomMatrixIndex()
            saveData()
            hudDelegate?.changedLife(to: life)
            hudDelegate?.changedLevel(to: level)
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
        saveLife()
        hudDelegate?.changedLife(to: life)
    }
    
    func updateScore(by amount: Int) {
        //guard !gameOver else { return }
        score += amount
        // TODO highscore
        print("update score: from \(score - amount) to: \(score)")
        print(score)
        saveScore()
        hudDelegate?.changedScore(to: score)
    }
    
    func getMatrixSize() -> (rows: Int, columns: Int) {
        if levelType == .normal {
            return levelData!.getMatrixSizeAt(index: matrixIndex)
        } else {
            return (rows: 4, columns: 4)
        }
    }
    
    func getMatrix(_ loaded: Bool = false) -> [[Int]] {
        if loaded {
            return matrix
        } else {
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
    }
    
    func getCardCount() -> Int {
        if levelType == .normal {
            return levelData!.cards
        } else if levelType == .bonus1 {
            return 12
        } else {
            return 16
        }
    }
    
    func getCardData(_ sets: CardSets, _ data: CardsData) -> [CardData]? {
        if levelType == .normal {
            let cardSets = sets.getCardSetsWithDifficulty(levelData!.difficulty)
            let index = Int(arc4random_uniform(UInt32(cardSets.count)))
            print("found sets: \(cardSets.count) index: \(index)")
            let cardSet = cardSets[Int(arc4random_uniform(UInt32(cardSets.count)))]
            var cards = [CardData]()
            for id in cardSet.cards {
                cards.append(data.getCardDataWithId(id)!)
            }
            return cards
        } else {
            return data.cards
        }
    }
    
    func saveData() {
        if !gameOver && level > 1 {
            print("saving data: level: \(level) matrixIndex: \(matrixIndex) score: \(score) life: \(life)\nlifeEachLevel:\(lifeEachLevel) upgradeMulti: \(upgradeMulti) chainMulti: \(chainMulti)")
            let defaults = UserDefaults.standard
            defaults.set(level, forKey: "game_data_level")
            defaults.set(matrixIndex, forKey: "game_data_matrix_Index")
            defaults.set(score, forKey: "game_data_score")
            defaults.set(life, forKey: "game_data_life")
            defaults.set(lifeCounter, forKey: "game_data_life_counter")
            defaults.set(lifeEachLevel, forKey: "game_data_life_each_level")
            defaults.set(upgradeMulti, forKey: "game_data_upgrade_multi")
            defaults.set(chainMulti, forKey: "game_data_chain_multi")
            defaults.set(remainingCards, forKey: "game_data_remaining_cards")
            defaults.set(true, forKey: "game_data_valid")
        }
    }
    
    func hasValidData() -> Bool {
        return UserDefaults.standard.bool(forKey: "game_data_valid")
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
    
    func saveScore() {
        if level > 1 && remainingCards >= 2 {
            UserDefaults.standard.set(score, forKey: "game_data_score")
        }
    }
    
    func invalidateData() {
        if level > 1 {
            UserDefaults.standard.set(false, forKey: "game_data_valid")
        }
    }
    
    func loadGameData() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "game_data_valid")
        level = defaults.integer(forKey: "game_data_level")
        matrixIndex = defaults.integer(forKey: "game_data_matrix_Index")
        score = defaults.integer(forKey: "game_data_score")
        life = defaults.integer(forKey: "game_data_life")
        lifeCounter = defaults.integer(forKey: "game_data_life_counter")
        lifeEachLevel = defaults.integer(forKey: "game_data_life_each_level")
        upgradeMulti = defaults.integer(forKey: "game_data_upgrade_multi")
        chainMulti = defaults.integer(forKey: "game_data_chain_multi")
        maxChain = defaults.integer(forKey: "game_data_max_chain")
        matrix = defaults.array(forKey: "game_data_matrix") as! [[Int]]
        remainingCards = defaults.integer(forKey: "game_data_remaining_cards")
        print("loaded data: level: \(level) matrixIndex: \(matrixIndex) score: \(score) life: \(life)\nlifeEachLevel:\(lifeEachLevel) upgradeMulti: \(upgradeMulti) chainMulti: \(chainMulti)")
        if let levelData = Game.levelsData!.getLevelData(for: level) {
            self.levelData = levelData
        }
        hudDelegate?.changedLife(to: life)
        hudDelegate?.changedLevel(to: level)
        hudDelegate?.changedScore(to: score)
        gameDelegate?.didLoadGameData()
    }
    
    func saveMatrix(_ matrix: [[Int]]) {
        if level > 1 {
            UserDefaults.standard.set(matrix, forKey: "game_data_matrix")
        }
    }
    
    func setRemainingCardsTo(_ value: Int) {
        remainingCards = remainingCards - value
        if remainingCards < 0 {
            remainingCards = 0
        }
        saveRemainingCards()
    }
    
    func saveRemainingCards() {
        if level > 1 {
            UserDefaults.standard.set(remainingCards, forKey: "game_data_remaining_cards")
        }
    }
    
    func saveChainMulti() {
        if level > 1 {
            UserDefaults.standard.set(chainMulti, forKey: "game_data_chain_multi")
        }
    }
    
    func saveMaxChain() {
        if level > 1 {
            UserDefaults.standard.set(maxChain, forKey: "game_data_max_chain")
        }
    }
    
    func saveLife() {
        if level > 1 {
            UserDefaults.standard.set(life, forKey: "game_data_life")
        }
    }
}
