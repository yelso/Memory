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
    var game = Game()
    var gameOverNode : GameOverNode!
    var cardSets: CardSets?
    var cardsData: CardsData?
    
    var bonusString = ["U", "L", "M"]
    var foundString = [String]()
    
    var cardSelectionQueue = [Card]()
    //var levelsData: LevelsData!
    
    var lastBonus = Game.LevelType.bonus1
    var cardMatrix = [[Int]]()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let image = UserDefaults.standard.string(forKey: "background")
        let bgNode = SKSpriteNode(imageNamed: image!)
        bgNode.zPosition = -10
        self.addChild(bgNode)
        hud = Hud(self.size)
        gameOverNode = GameOverNode(self.size, self)
        game.hudDelegate = hud
        game.gameDelegate = self
        gameNode = SKSpriteNode(color: .clear, size: self.size)
        gameNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(gameNode)
        self.addChild(hud)
        self.addChild(gameOverNode)
        cardsData = FileUtils.loadCards(named: Constants.cardDataName)
        cardData = cardsData!.cards
        cardSets = FileUtils.loadCardSets(named: Constants.cardSetName)
        if game.hasValidData() {
            let alertController = UIAlertController(title: "Spiel fortsetzen", message: "Möchtest du das letzte Spiel fortsetzen?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Neues Spiel", style: .cancel) { (_) in
                self.game.invalidateData()
                self.game.newGame()
                self.nextLevel()
            }
            let confirmAction = UIAlertAction(title: "Laden", style: .default) { (_) in
               self.game.loadGameData()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            DispatchQueue.main.async {
                self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        } else {
            game.newGame()
            nextLevel()
        }
    }
    
    func didLoadGameData() {
        print("loaded game")
        createMatrix(withUpgrade: nil, loaded: true)
    }
    
    func nextLevel() {
        //Bonuslevel
        cardSelectionQueue.removeAll()
        if game.levelType == .normal && (game.level+1) % 4 == 0 {
            if game.lastBonusType == 0 {
                game.lastBonusType = 1
                game.levelType = .bonus2
                lastBonus = .bonus2
            } else {
                 game.lastBonusType = 0
                game.levelType = .bonus1
                lastBonus = .bonus1
            }
            game.saveLastType()
            //levelType = ((arc4random_uniform(100) + 1) <= 100) ? .bonus1 : .bonus2
            createMatrix(withUpgrade: nil)
        } else {
            game.levelType = .normal
            game.nextLevel()
            //game.saveData()
            // calculate upgrade chance
            if (game.level > 1 && (arc4random_uniform(100) + 1) <= 40) {
                let random = (arc4random_uniform(100) + 1)
                let type = random <= 10 ? UpgradeType.life : (random <= 60) ? UpgradeType.multiplier2 : UpgradeType.multiplier5
                createMatrix(withUpgrade: type)
            } else {
                createMatrix(withUpgrade: nil)
            }
        }
    }
    
    func createMatrix(withUpgrade upgradeType: UpgradeType?, loaded: Bool = false) {
        let matrixSize = game.getMatrixSize()
            var cardList = [Card]()
        var data = game.getCardData(cardSets!, cardsData!)
        if loaded || data == nil {
            data = cardData
        }
        
        cardMatrix = game.getMatrix(loaded)
        //var matrixToSave = [[Int]](repeating: [Int](repeating: 0, count: matrixSize.columns), count: matrixSize.rows)
            allCards.removeAll()
            //var matrix = [[ActionNode]](repeating: [ActionNode](repeating: ActionNode(color: .clear, size: CGSize(width: 1, height: 1)), count: matrixSize.columns), count: matrixSize.rows)
        data!.shuffle()
        if !loaded {
            for index in 0..<game.getCardCount()/2 {
                let card1 = Card(id: data![index%data!.count].id, imageNamed: data![index%data!.count].name, self)
                let card2 = Card(id: data![index%data!.count].id, imageNamed: data![index%data!.count].name, self)
                        //index +13
                cards[data![index%data!.count].id] = [card1, card2]
                
                cardList.append(card1)
                cardList.append(card2)
            }
            
            cardList.shuffle()
            game.setRemainingCardsTo(cardList.count)
        }
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
        
            var counter = 0
            for row in 0..<matrixSize.rows {
                for column in 0..<matrixSize.columns {
                    if !loaded && cardMatrix[row][column] == 1 {
                        let card = cardList.popLast()!
                        let x = (spaceWNeeded/2 * -1) + (column * size) + (column * padding) + (size/2)
                        let y = (spaceHNeeded/2 - size/2) - (row * size) - (row * padding)
                        card.position = CGPoint(x: x, y: y)
                        card.row = row
                        card.column = column
                        cardMatrix[row][column] = card.id
                        card.isUserInteractionEnabled = false
                        gameNode.addChild(card)
                        allCards.append(card)
                    } else if cardMatrix[row][column] >= 101 {
                        counter += 1
                        print("loaded cards: \(counter)")
                        print("matrix >= 101")
                        let card = Card(id: cardMatrix[row][column], imageNamed: cardsData!.getCardDataWithId(cardMatrix[row][column])!.name, self)
                        if cards[card.id] == nil {
                            cards[card.id] = [card]
                        } else {
                            cards[card.id]!.append(card)
                        }
                        let x = (spaceWNeeded/2 * -1) + (column * size) + (column * padding) + (size/2)
                        let y = (spaceHNeeded/2 - size/2) - (row * size) - (row * padding)
                        card.position = CGPoint(x: x, y: y)
                        card.row = row
                        card.column = column
                        cardMatrix[row][column] = card.id
                        card.isUserInteractionEnabled = false
                        gameNode.addChild(card)
                        allCards.append(card)
                    }
                }
            }
        if loaded {
            game.saveMatrix(cardMatrix)
        }
        
            if game.levelType == .normal {
                if upgradeType != nil {
                    let random = arc4random_uniform(UInt32(allCards.count))
                    let upgradeCard = allCards[Int(random)]
                    upgradeCard.addUpgrade(upgradeType!)
                }
                
                if loaded && game.remainingCards <= 2 {
                    print("remaining cards: \(game.remainingCards)")
                    gameNode.children.forEach { (node) in
                        node.run(SKAction.scale(to: 1.0, duration: 0.2))
                    }
                    self.gameNode.run(afterDelay: 0.5) {
                        self.autoEndLevel()
                    }
                } else {
                    gameNode.children.forEach { (node) in
                        node.run(SKAction.sequence([
                            SKAction.scale(to: 1.0, duration: 0.2),
                            SKAction.run({
                                node.isUserInteractionEnabled = true
                            })
                            ]))
                    }
                }
                
            } else if game.levelType == .bonus1 {
                if bonusString.isEmpty {
                    bonusString = ["U", "L", "M"]
                }
                
                self.hud.displayBonus(for: game.levelType)
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
                    c.fakeId = index+1
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
                self.hud.displayBonus(for: game.levelType)
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
        game.chainMulti += 1
        //game.setRemainingCardsTo(game.remainingCards-2)
        for card in self.cards.values {
            card[0].switchTexture(toFront: true)
            card[1].switchTexture(toFront: true)
        }
        print("remaining card values \(self.cards.values.count)")
        for card in self.cards.values {
            //cardMatrix[card[0].row!][card[1].column!] = 0
            var upgradeType : UpgradeType? // TODO clean code
            var amount: Int = 1
            if card[0].hasUpgrade() {
                upgradeType = card[0].upgrade!.type
                amount = card[0].upgrade!.getUpgradeAmount()
                if upgradeType == .life {
                    game.updateLife(by: amount)
                }
            } else if card[1].hasUpgrade() {
                upgradeType = card[1].upgrade!.type
                amount = card[1].upgrade!.getUpgradeAmount()
                if upgradeType == .life {
                    game.updateLife(by: amount)
                }
            }
            displayPoints([card[0].position, card[1].position], points: points!, upgradeMulti: amount)
            //displayPoints(, points: 5, upgradeMulti: amount)
        }
        
        //game.saveMatrix(cardMatrix)
        if self.cards.values.count <= 0 {
            print("removing instantly")
            self.gameNode.run(SKAction.afterDelay(0.2, runBlock: {
                self.cards.removeAll()
                self.nextLevel()
            }))
        } else {
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
    }
    
    func gameOver() {
        game.invalidateData()
        for card in allCards {
            if !card.faceUp {
                card.switchTexture(toFront: true)
            }
        }
        self.run(SKAction.afterDelay(2, runBlock: {
            if self.game.level > 1 {
                self.hud.run(SKAction.fadeOut(withDuration: 0.3))
                self.gameOverNode.showGameOverNode(with: self.game)
            } else {
                self.selectedCardId = -1
                 self.cards.removeAll()
                 self.gameNode.children.forEach({ (node) in
                    if let node = node as? Card {
                        node.removeFromParentAnimated()
                    }
                 })
                 self.run(SKAction.afterDelay(0.5, runBlock: {
                    self.game.newGame()
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
            game.chainMulti += 1
            var upgradeType : UpgradeType?
            var amount: Int = 1
            for card2 in selectedCards {
                if card2.hasUpgrade() {
                    upgradeType = card2.upgrade!.type
                    amount = card2.upgrade!.getUpgradeAmount()
                    if upgradeType == .life {
                        game.updateLife(by: amount)
                    }
                    break
                }
                cardMatrix[card2.row!][card2.column!] = 0
                game.saveMatrix(cardMatrix)
                game.setRemainingCardsTo(game.remainingCards-1)
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
            // MARK: REMOVE
        } else {
            //selectedCardId = -1
            game.updateLife(by: -1)
            self.gameNode.run(afterDelay: 0.75) {
                if self.game.life > 0 {
                    self.game.chainMulti = 0
                    selectedCards.forEach({ (card) in
                        card.invalidateUpgrade()
                        card.switchTexture(toFront: false)
                    })
                    if self.game.life > 0 {
                        self.childInteractions(enabled: true)
                    }
                } else {
                    self.gameOver()
                }
            }
        }
    }
    
    func didSelectCard(_ selectedCard: Card) {
        print("lv: \(game.level)")
        print("selected \(selectedCard.id)")
        
        if game.levelType == .normal {
            if cardSelectionQueue.isEmpty {
                cardSelectionQueue.append(selectedCard)
                selectedCard.switchTexture(toFront: true)
            } else {
                handleCardSelection(with: [cardSelectionQueue.removeFirst(), selectedCard])
            }
            return
        } else if game.levelType == .bonus2 {
            
        }
        
        if game.levelType == .bonus2 {
            if let nextCard = cardsToSelect.popLast() {
                if nextCard.fakeId == selectedCard.fakeId { // selected matches
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
                game.chainMulti += 1
                selectedCard.switchTexture(toFront: true)
                if let selectedCards = self.cards[selectedCard.id] {
                    var upgradeType : UpgradeType?
                    var amount: Int = 1
                    if game.levelType == .normal {
                        for card2 in selectedCards {
                            if card2.hasUpgrade() {
                                upgradeType = card2.upgrade!.type
                                amount = card2.upgrade!.getUpgradeAmount()
                                if upgradeType == .life {
                                    game.updateLife(by: amount)
                                }
                                break
                            }
                        }
                    }
                    
                    var positions = [CGPoint]()
                    for card2 in selectedCards {
                        positions.append(card2.position)
                    }
                    self.displayPoints(positions, points: 10, upgradeMulti: (game.levelType == .normal && upgradeType != nil && upgradeType != .life) ? amount : 1)
                    
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
                if game.levelType == .normal {
                    //selectedCardId = -1
                    selectedCard.switchTexture(toFront: true)
                    
                    game.updateLife(by: -1)
                    self.gameNode.run(afterDelay: 1) {
                        if self.game.life > 0 {
                            self.game.chainMulti = 0
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
                            if self.game.life > 0 {
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
        var points = points * (game.levelType == .normal ? game.chainMulti : 1) * upgradeMulti
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
            print("multi: \(game.chainMulti) calc: \(game.chainMulti * upgradeMulti)")
            
            if game.levelType == .normal && game.chainMulti > 1 {
                print("curP: \(points) multi: \(game.chainMulti) upgrade: \(upgradeMulti) perCard: \(pointsEachCard * game.chainMulti * upgradeMulti) ges: \(points)")
                //points += pointsEachCard * gameData.chainMulti * upgradeMulti
                print("new points: \(points)")
                let multiLabel = SKLabelNode(text: "x\(game.chainMulti*upgradeMulti)")
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
        self.game.updateScore(by: points)
    }
    
    func startNewGame() {
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
            self.game.newGame()
            self.nextLevel()
        }))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
