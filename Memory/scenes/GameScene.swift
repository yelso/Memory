//
//  GameScene.swift
//  Memory
//
//  Created by Puja Dialehabady on 22.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, CardDelegate, GameDelegate {
    
    enum LevelType {
        case normal
        case bonus1
        case bonus2
    }
    
    var levelType = LevelType.normal
    var count = 0
    var cards = [Int: [Card]]()
    var selectedCardId = -1
    var gameNode: SKSpriteNode!
    var cardData : [CardData]?
    var bonusCardData = [CardData]()
    var cardsToSelect = [Card]()
    var allCards = [Card]()
    var bonus = 0
    var hud : Hud!
    var gameData = GameData()
    var gameOverNode : GameOverNode!
    var cardSets: CardSets?
    var cardsData: CardsData?
    
    var bonusString = ["U", "L", "M"]
    var foundString = [String]()
    
    var cardSelectionQueue = [Card]()
    //var levelsData: LevelsData!
    
    var lastBonus = LevelType.bonus1
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -10
        self.addChild(bgNode)
        hud = Hud(self.size)
        gameOverNode = GameOverNode(self.size, self)
        gameData.delegate = hud
        gameData.newGame()

        gameNode = SKSpriteNode(color: .clear, size: self.size)
        gameNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
        self.addChild(gameNode)
        self.addChild(hud)
        self.addChild(gameOverNode)
        cardsData = FileUtils.loadCards(named: "cards1")
        //levelsData = FileUtils.loadLevelData()!
        cardData = cardsData!.cards
        cardSets = FileUtils.loadCardSets(named: "cardSets")
        /*for card in cardData! {
            print(card.id)
            if card.id <= 9 {
                bonusCardData.append(card)
            }
        }*/
        //cardData!.removeSubrange(0...9)
        nextLevel()
    }
    
    func loadGame() {
        // TODO
    }
    
    func nextLevel() {
        //Bonuslevel
        cardSelectionQueue.removeAll()
        if levelType == .normal && (gameData.level+1) % 2 == 0 {
            if lastBonus == .bonus1 {
                levelType = .bonus2
                lastBonus = .bonus2
            } else {
                levelType = .bonus1
                lastBonus = .bonus1
            }
            //levelType = ((arc4random_uniform(100) + 1) <= 100) ? .bonus1 : .bonus2
            createMatrix(withUpgrade: nil)
        } else {
            levelType = .normal
            gameData.nextLevel()
            // calculate upgrade chance
            if (gameData.level > 1 && (arc4random_uniform(100) + 1) <= 40) {
                let random = (arc4random_uniform(100) + 1)
                let type = random <= 10 ? UpgradeType.life : (random <= 60) ? UpgradeType.multiplier2 : UpgradeType.multiplier5
                createMatrix(withUpgrade: type)
            } else {
                createMatrix(withUpgrade: nil)
            }
        }
    }
    
    func createMatrix(withUpgrade upgradeType: UpgradeType?) {
        //if let levelData = levelsData.getLevelData(for: gameData.level) {
        let matrixSize = gameData.getMatrixSize(for: levelType)
            var cardList = [Card]()
        var data = gameData.getCardData(for: levelType, cardSets!, cardsData!)
        if data == nil {
            data = cardData
        }
        let cardMatrix = gameData.getMatrix(for: levelType)
            allCards.removeAll()
            var matrix = [[ActionNode]](repeating: [ActionNode](repeating: ActionNode(color: .clear, size: CGSize(width: 1, height: 1)), count: matrixSize.columns), count: matrixSize.rows)
            data!.shuffle()
            for index in 0..<gameData.getCardCount(for: levelType)/2 {
                let card1 = Card(id: index + 13, imageNamed: data![index%data!.count].name, self)
                let card2 = Card(id: index + 13, imageNamed: data![index%data!.count].name, self)
                        
                cards[index + 13] = [card1, card2]
                    
                cardList.append(card1)
                cardList.append(card2)
            }
            
            count = cards.count
            cardList.shuffle()
            let size = Int(Constants.cardBackTexture.size().width)
            var padding = 16
            if UIDevice.current.userInterfaceIdiom == .phone {
                if self.size.height <= 667 { // iphone se, 8 and below
                    padding = 10
                } else if self.size.height < 812 { // iphone 8 plus and below
                    padding = 20
                }
            } else {
                padding = 35
            }
            
            let spaceWNeeded = size * matrixSize.columns + padding * (matrixSize.columns - 1)
            let spaceHNeeded = size * matrixSize.rows + padding * (matrixSize.rows - 1)
        
            for row in 0..<matrixSize.rows {
                for column in 0..<matrixSize.columns {
                    if cardMatrix[row][column] == 1 {
                        let card = cardList.popLast()!
                        let x = (spaceWNeeded/2 * -1) + (column * size) + (column * padding) + (size/2)
                        let y = (spaceHNeeded/2 - size/2) - (row * size) - (row * padding)
                        card.position = CGPoint(x: x, y: y)
                        matrix[row][column] = card
                        gameNode.addChild(card)
                        allCards.append(card)
                    } /*else if levelType == .bonus1 {
                        
                        let card = Card(id: <#T##Int#>, imageNamed: <#T##String#>, <#T##delegate: CardDelegate##CardDelegate#>)
                        let x = (spaceWNeeded/2 * -1) + (column * size) + (column * padding) + (size/2)
                        let y = (spaceHNeeded/2 - size/2) - (row * size) - (row * padding)
                        card.position = CGPoint(x: x, y: y)
                        matrix[row][column] = card
                        gameNode.addChild(card)
                        allCards.append(card)
                    } */
                }
            }
            
            if levelType == .normal {
                if upgradeType != nil {
                    let random = arc4random_uniform(UInt32(allCards.count))
                    let upgradeCard = allCards[Int(random)]
                    upgradeCard.addUpgrade(upgradeType!)
                }
                
                gameNode.children.forEach { (node) in
                    node.run(SKAction.sequence([
                        SKAction.scale(to: 1.0, duration: 0.2),
                        SKAction.run({
                            node.isUserInteractionEnabled = true
                        })
                        ]))
                }
                
            } else if levelType == .bonus1 {
                if bonusString.isEmpty {
                    bonusString = ["U", "L", "M"]
                }
                /*for row in 0..<matrixSize.rows {
                    for column in 0..<matrixSize.columns {
                        if cardMatrix[row][column] == 0 {
                            let card = Card(id: 1, imageNamed: "u", self)
                            let x = (spaceWNeeded/2 * -1) + (column * size) + (column * padding) + (size/2)
                            let y = (spaceHNeeded/2 - size/2) - (row * size) - (row * padding)
                            card.position = CGPoint(x: x, y: y)
                            matrix[row][column] = card
                            gameNode.addChild(card)
                            allCards.append(card)
                        }
                    }
                }
                */
                self.hud.displayBonus(for: levelType)
                self.gameNode.run(SKAction.sequence([
                    SKAction.run({
                        for card in self.allCards {
                            card.run(SKAction.scale(to: 1.0, duration: 0.2))
                        }
                    }),
                    SKAction.run({
                        for card in self.allCards {
                            card.switchTexture(toFront: true)
                        }
                    }),
                    SKAction.afterDelay(4, runBlock: {
                        for card in self.allCards {
                            card.switchTexture(toFront: false)
                        }
                        self.childInteractions(enabled: true)
                    })
                    ]))
            } else { // levelType = .bonus2
                //self.hud.displayBonus(for: levelType)
                for card in self.allCards {
                    card.run(SKAction.scale(to: 1.0, duration: 0.2))
                }
                allCards.shuffle()
                cardsToSelect.removeAll()
                let randomCardsAmount = Int(arc4random_uniform(5) + 5)
                print("randomCards: \(randomCardsAmount)")
                for index in 0..<randomCardsAmount {
                    // TODO: properly add these cards and dont change their textures like this
                    let c = allCards[index]
                    c.frontTexture = SKTexture(imageNamed: "\(index+1)")
                    c.id = index+1
                    cardsToSelect.append(c)
                    cardsToSelect[index].run(SKAction.sequence([
                        SKAction.afterDelay(Double(index) * 1 + 2.0, runBlock: {
                            self.cardsToSelect[index].switchTexture(toFront: true)
                            print("turned card to front \(self.cardsToSelect[index].id)")
                        }),
                        SKAction.afterDelay(1, runBlock: {
                            self.cardsToSelect[index].switchTexture(toFront: false)
                        })
                        ]))
                }
                self.hud.displayBonus(for: levelType)
                //self.hud.displayCardsToSelect(cardsToSelect)
                self.gameNode.run(afterDelay: TimeInterval(randomCardsAmount) + 2.5) {
                    self.cardsToSelect.reverse()
                    self.childInteractions(enabled: true)
                }
            }
            
        //} else {
         //  print("error")
        
    }
    
    func autoEndLevel(points: Int? = 10) {
        // last two left cards disapear automatically
        gameData.chainMulti += 1
        for card in self.cards.values {
            card[0].switchTexture(toFront: true)
            card[1].switchTexture(toFront: true)
        }
        for card in self.cards.values {
            var upgradeType : UpgradeType? // TODO clean code
            var amount: Int = 1
            if card[0].hasUpgrade() {
                upgradeType = card[0].upgrade!.type
                amount = card[0].upgrade!.getUpgradeAmount()
                if upgradeType == .life {
                    gameData.updateLife(by: amount)
                }
            } else if card[1].hasUpgrade() {
                upgradeType = card[1].upgrade!.type
                amount = card[1].upgrade!.getUpgradeAmount()
                if upgradeType == .life {
                    gameData.updateLife(by: amount)
                }
            }
            displayPoints([card[0].position, card[1].position], points: points!, upgradeMulti: amount)
            //displayPoints(, points: 5, upgradeMulti: amount)
        }
        
        self.gameNode.run(SKAction.afterDelay(2, runBlock: {
            for card in self.cards.values {
                card[0].removeFromParentAnimated()
                card[1].removeFromParentAnimated()
            }
            self.gameNode.run(SKAction.afterDelay(0.2, runBlock: {
                self.cards.removeAll()
                self.nextLevel()
            }))
        }))
    }
    
    func gameOver() {
        for card in allCards {
            if !card.faceUp {
                card.switchTexture(toFront: true)
            }
        }
        self.run(SKAction.afterDelay(2, runBlock: {
            if self.gameData.level > 1 {
                self.hud.run(SKAction.fadeOut(withDuration: 0.3))
                self.gameOverNode.showGameOverNode(with: self.gameData)
            } else {
                self.selectedCardId = -1
                 self.cards.removeAll()
                 self.gameNode.children.forEach({ (node) in
                    if let node = node as? Card {
                        node.removeFromParentAnimated()
                    }
                 })
                 self.run(SKAction.afterDelay(0.5, runBlock: {
                    self.gameData.newGame()
                    self.nextLevel()
                 }))
            }
        }))
    }
    
    func handleCardSelection(with selectedCards: [Card]) {
        selectedCards[1].switchTexture(toFront: true)
        if selectedCards[0].id == selectedCards[1].id { // match
            self.cards.removeValue(forKey: selectedCards[1].id)
            if (self.cards.values.count <= 1) {
                self.childInteractions(enabled: false)
            }
            gameData.chainMulti += 1
            var upgradeType : UpgradeType?
            var amount: Int = 1
            for card2 in selectedCards {
                if card2.hasUpgrade() {
                    upgradeType = card2.upgrade!.type
                    amount = card2.upgrade!.getUpgradeAmount()
                    if upgradeType == .life {
                        gameData.updateLife(by: amount)
                    }
                    break
                }
            }
                
            var positions = [CGPoint]()
            for card2 in selectedCards {
                positions.append(card2.position)
            }
            self.displayPoints(positions, points: 10, upgradeMulti: (upgradeType != nil && upgradeType != .life) ? amount : 1)
            
            self.gameNode.run(afterDelay: 1) {
                for card2 in selectedCards {
                    card2.removeFromParentAnimated()
                }
                if (self.cards.values.count <= 1) {
                    self.autoEndLevel()
                } else {
                    print("remaining cards: \(self.cards.values.count)")
                }
            }
        } else {
            //selectedCardId = -1
            gameData.updateLife(by: -1)
            self.gameNode.run(afterDelay: 0.75) {
                if self.gameData.life > 0 {
                    self.gameData.chainMulti = 0
                    selectedCards.forEach({ (card) in
                        card.invalidateUpgrade()
                        card.switchTexture(toFront: false)
                    })
                    if self.gameData.life > 0 {
                        self.childInteractions(enabled: true)
                    }
                } else {
                    self.gameOver()
                }
            }
        }
    }
    
    func didSelectCard(_ selectedCard: Card) {
        print("lv: \(gameData.level)")
        print("selected \(selectedCard.id)")
        
        if levelType == .normal {
            if cardSelectionQueue.isEmpty {
                cardSelectionQueue.append(selectedCard)
                selectedCard.switchTexture(toFront: true)
            } else {
                handleCardSelection(with: [cardSelectionQueue.removeFirst(), selectedCard])
            }
            return
        } else if levelType == .bonus2 {
            
        }
        
        if levelType == .bonus2 {
            if let nextCard = cardsToSelect.popLast() {
                if nextCard.id == selectedCard.id { // selected matches
                    selectedCard.switchTexture(toFront: true)
                    self.displayPoints([selectedCard.position], points: 50, upgradeMulti: 1)
                    //self.hud.selectNextCard()
                    if cardsToSelect.count == 0 {
                        self.gameNode.run(SKAction.afterDelay(2, runBlock: {
                            for card in self.cards.values {
                                card[0].removeFromParentAnimated()
                                card[1].removeFromParentAnimated()
                            }
                            self.gameNode.run(SKAction.afterDelay(0.2, runBlock: {
                                self.cards.removeAll()
                                self.hud.hideBonus()
                                self.nextLevel()
                            }))
                        }))
                    }
                } else { // selected does not match
                    selectedCard.shake()
                    self.gameNode.run(SKAction.sequence([
                        SKAction.afterDelay(0.5, runBlock: {
                            nextCard.switchTexture(toFront: true)
                            for index in 0..<self.cardsToSelect.count {
                                if let card = self.cardsToSelect.popLast() {
                                    card.run(afterDelay: TimeInterval(0.5 + Double(index) * 0.5), {
                                        card.switchTexture(toFront: true)
                                    })
                                }
                            }
                        }),
                        SKAction.afterDelay(TimeInterval(Double(self.cardsToSelect.count) * 0.5 + 1), runBlock: {
                            for card in self.cards.values {
                                card[0].removeFromParentAnimated()
                                card[1].removeFromParentAnimated()
                            }
                        }),
                        SKAction.afterDelay(TimeInterval(1), runBlock: {
                            self.cards.removeAll()
                            self.hud.hideBonus()
                            self.nextLevel()
                        })
                        ]))
                }
            } else {
                self.gameNode.run(SKAction.afterDelay(2, runBlock: {
                    for card in self.cards.values {
                        card[0].removeFromParentAnimated()
                        card[1].removeFromParentAnimated()
                    }
                    self.gameNode.run(SKAction.afterDelay(0.2, runBlock: {
                        self.cards.removeAll()
                        self.hud.hideBonus()
                        self.nextLevel()
                    }))
                }))
            }
            return
        }
        
        if selectedCardId == -1 { // selected card is first card
            selectedCardId = selectedCard.id
            selectedCard.switchTexture(toFront: true)
        } else { // selected card is 2nd card
            self.childInteractions(enabled: false)
            if selectedCard.id == selectedCardId { // selected cards match
                //selectedCardId = -1
                gameData.chainMulti += 1
                selectedCard.switchTexture(toFront: true)
                if let selectedCards = self.cards[selectedCard.id] {
                    var upgradeType : UpgradeType?
                    var amount: Int = 1
                    if levelType == .normal {
                        for card2 in selectedCards {
                            if card2.hasUpgrade() {
                                upgradeType = card2.upgrade!.type
                                amount = card2.upgrade!.getUpgradeAmount()
                                if upgradeType == .life {
                                    gameData.updateLife(by: amount)
                                }
                                break
                            }
                        }
                    }
                    
                    var positions = [CGPoint]()
                    for card2 in selectedCards {
                        positions.append(card2.position)
                    }
                    self.displayPoints(positions, points: 10, upgradeMulti: (levelType == .normal && upgradeType != nil && upgradeType != .life) ? amount : 1)
                    
                    self.gameNode.run(afterDelay: 1) {
                        //if let selectedCards = self.cards[card.id] {
                            for card2 in selectedCards {
                                card2.removeFromParentAnimated()
                            }
                        //}
                        self.cards.removeValue(forKey: selectedCard.id)
                        self.childInteractions(enabled: true)
                        if (self.cards.values.count <= 1) {
                            self.autoEndLevel()
                        }
                    }
                }
                selectedCardId = -1
            } else { // selected cards don't match
                if levelType == .normal {
                    //selectedCardId = -1
                    selectedCard.switchTexture(toFront: true)
                    
                    gameData.updateLife(by: -1)
                    self.gameNode.run(afterDelay: 1) {
                        if self.gameData.life > 0 {
                            self.gameData.chainMulti = 0
                            selectedCard.invalidateUpgrade()
                            selectedCard.switchTexture(toFront: false)
                            if let selectedCards = self.cards[self.selectedCardId] {
                                for card2 in selectedCards {
                                    if card2.faceUp {
                                        card2.invalidateUpgrade()
                                        card2.switchTexture(toFront: false)
                                    }
                                }
                            }
                            self.selectedCardId = -1
                            if self.gameData.life > 0 {
                                self.childInteractions(enabled: true)
                            }
                        } else {
                            self.gameOver()
                        }
                        
                    }
                } else { // bonus level
                    for selectedCard in allCards {
                        if !selectedCard.faceUp {
                            selectedCard.switchTexture(toFront: true)
                        }
                    }
                    self.run(SKAction.afterDelay(2, runBlock: {
                        self.selectedCardId = -1
                        self.cards.removeAll()
                        self.gameNode.children.forEach({ (node) in
                            if let node = node as? Card {
                                node.removeFromParentAnimated()
                            }
                        })
                        self.run(SKAction.afterDelay(0.5, runBlock: {
                            self.hud.hideBonus()
                            self.nextLevel()
                        }))
                    }))
                }
            }
        }
    }
    
    func childInteractions(enabled: Bool) {
        self.gameNode.children.forEach({ (node) in
            node.isUserInteractionEnabled = enabled
        })
    }
    
    func displayPoints(_ pos: [CGPoint], points: Int, upgradeMulti: Int) {
        //var points = 0
        let pointsEachCard = points/pos.count
        var points = points * (levelType == .normal ? gameData.chainMulti : 1) * upgradeMulti
        print("bPoints: \(points) ePoints: \(pointsEachCard)")
        
        for position in pos {
            let pointsLabel = SKLabelNode(text: "\(pointsEachCard)")
            pointsLabel.fontSize = 24
            pointsLabel.fontName = Constants.scoreFontName
            pointsLabel.fontColor = UIColor(red:0.97, green:0.72, blue:0.19, alpha:1.0)
            let pointsNode = SKSpriteNode(color: .clear, size: CGSize(width: pointsLabel.frame.size.width, height: pointsLabel.frame.size.height))
            pointsNode.addChild(pointsLabel)
            pointsLabel.horizontalAlignmentMode = .center
            pointsLabel.verticalAlignmentMode = .center
            pointsLabel.addStroke(color: .black, width: 5)
            print("multi: \(gameData.chainMulti) calc: \(gameData.chainMulti * upgradeMulti)")
            
            if levelType == .normal && gameData.chainMulti > 1 {
                print("curP: \(points) multi: \(gameData.chainMulti) upgrade: \(upgradeMulti) perCard: \(pointsEachCard * gameData.chainMulti * upgradeMulti) ges: \(points)")
                //points += pointsEachCard * gameData.chainMulti * upgradeMulti
                print("new points: \(points)")
                let multiLabel = SKLabelNode(text: "x\(gameData.chainMulti*upgradeMulti)")
                multiLabel.fontColor = .red
                multiLabel.fontSize = 20
                multiLabel.fontName = "Marker Felt"
                pointsNode.size = CGSize(width: multiLabel.frame.width + pointsLabel.frame.size.width, height: multiLabel.frame.height + pointsLabel.frame.size.height + 5)
                pointsNode.addChild(multiLabel)
                multiLabel.horizontalAlignmentMode = .left
                multiLabel.verticalAlignmentMode = .center
                pointsLabel.horizontalAlignmentMode = .right
                multiLabel.position = CGPoint(x: pointsLabel.position.x - 10, y: pointsLabel.position.y)
                multiLabel.addStroke(color: .white, width: 5)
            }
            
            pointsNode.position = CGPoint(x: position.x + 20, y: position.y + 10)
            pointsNode.setScale(0)
            self.gameNode.addChild(pointsNode)
            let scaleUp = SKAction.scale(to: 1, duration: 0.2)
            let moveUp = SKAction.moveBy(x: 0, y: 70, duration: 1.4)
            pointsNode.run(SKAction.group([
                scaleUp, moveUp,
                SKAction.afterDelay(1.4, runBlock: {
                    pointsNode.removeFromParent()
                })
                ]))
        }
        self.gameData.updateScore(by: points)
    }
    
    func newGame() {
        self.selectedCardId = -1
        self.cards.removeAll()
        self.gameOverNode.hide()
        self.gameNode.children.forEach({ (node) in
            if let node = node as? Card {
                node.removeFromParentAnimated()
            }
        })
        
        self.run(SKAction.afterDelay(0.5, runBlock: {
            self.hud.run(SKAction.fadeIn(withDuration: 0.3))
            self.gameData.newGame()
            self.nextLevel()
        }))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
