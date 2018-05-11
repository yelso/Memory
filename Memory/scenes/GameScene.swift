//
//  GameScene.swift
//  Memory
//
//  Created by Puja Dialehabady on 22.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, CardDelegate {
    
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
    var cardsToSelect = [Card]()
    var allCards = [Card]()
    
    var hud : Hud!
    var gameData = GameData()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        hud = Hud(self.size)
        gameData.delegate = hud
        gameData.newGame()

        gameNode = SKSpriteNode(color: .clear, size: self.size)
        gameNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
        self.addChild(gameNode)
        self.addChild(hud)
        let cardsData = FileUtils.loadCards(named: "cards1")
        cardData = cardsData!.cards
        nextLevel()
    }
    
    func loadGame() {
        // TODO
    }
    
    func nextLevel() {
        //Bonuslevel
        if levelType == .normal && (gameData.level+1) % 5 == 0 {
            levelType = ((arc4random_uniform(100) + 1) <= 50) ? .bonus1 : .bonus2
            createMatrixAndPlaceCards(withUpgrade: nil)
        } else {
            levelType = .normal
            gameData.nextLevel()
            // calculate upgrade chance
            if (gameData.level > 1 && (arc4random_uniform(100) + 1) <= 50) {
                let random = (arc4random_uniform(100) + 1)
                let type = random <= 10 ? UpgradeType.life : (random <= 50) ? UpgradeType.multiplier2 : UpgradeType.multiplier5
                createMatrixAndPlaceCards(withUpgrade: type)
            } else {
                createMatrixAndPlaceCards(withUpgrade: nil)
            }
        }
    }
    
    func createMatrixAndPlaceCards(withUpgrade upgradeType: UpgradeType?) {
        let matrixSize = getSizeForLevel()
        var cardList = [Card]()
        allCards.removeAll()
        var matrix = [[ActionNode]](repeating: [ActionNode](repeating: ActionNode(color: .clear, size: CGSize(width: 1, height: 1)), count: matrixSize.columns), count: matrixSize.rows)
        cardData!.shuffle()
        for index in 0..<((matrixSize.rows * matrixSize.columns)/2) {
            let card1 = Card(id: index + 1, imageNamed: cardData![index%6].name, self)
            let card2 = Card(id: index + 1, imageNamed: cardData![index%6].name, self)
            
            cards[index + 1] = [card1, card2]
            
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
                let card = cardList.popLast()!
                let x = (spaceWNeeded/2 * -1) + (column * size) + (column * padding) + (size/2)
                let y = (spaceHNeeded/2 - size/2) - (row * size) - (row * padding)
                card.position = CGPoint(x: x, y: y - Int(Constants.hudHeight))
                matrix[row][column] = card
                gameNode.addChild(card)
                allCards.append(card)
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
                SKAction.afterDelay(2, runBlock: {
                    for card in self.allCards {
                        card.switchTexture(toFront: false)
                    }
                    self.childInteractions(enabled: true)
                })
            ]))
        } else { // levelType = .bonus2
            for card in self.allCards {
                card.run(SKAction.scale(to: 1.0, duration: 0.2))
            }
            allCards.shuffle()
            cardsToSelect.removeAll()
            for index in 0..<6 {
                cardsToSelect.append(allCards[index])
                cardsToSelect[index].run(SKAction.sequence([
                    SKAction.afterDelay(Double(index) * 1 + 0.5, runBlock: {
                        self.cardsToSelect[index].switchTexture(toFront: true)
                        print("turned card to front \(self.cardsToSelect[index].id)")
                    }),
                ]))
            }
            self.gameNode.run(SKAction.sequence([
                SKAction.afterDelay(6, runBlock: {
                    for card in self.allCards {
                        if !card.faceUp {
                            card.switchTexture(toFront: true)
                        }
                    }
                }),
                SKAction.afterDelay(1, runBlock: {
                    for card in self.allCards {
                        card.switchTexture(toFront: false)
                    }
                    self.cardsToSelect.reverse()
                    self.childInteractions(enabled: true)
                })
            ]))
        }
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
    
    func getSizeForLevel() -> (rows: Int, columns: Int) {
        if levelType == .bonus1 {
            return (rows: 3, columns: 2)
        } else if levelType == .bonus2 {
            return (rows: 4, columns: 4)
        }
        switch gameData.level {
        case 1:
            if UIDevice.current.userInterfaceIdiom == .phone {
                return (rows: 2, columns: 2)
            } else {
                return (rows: 2, columns: 2)
            }
        case 2:
            if UIDevice.current.userInterfaceIdiom == .phone {
                return (rows: 2, columns: 3)
            } else {
                return (rows: 2, columns: 3)
            }
        case 3:
            return (rows: 4, columns: 3)
        default:
            return (rows: 4, columns: 4)
        }
    }
    
    func gameOver() {
        for card in allCards {
            if !card.faceUp {
                card.switchTexture(toFront: true)
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
                self.gameData.newGame()
                self.nextLevel()
            }))
        }))
    }
    
    func didSelectCard(_ card: Card) {
        print("lv: \(gameData.level)")
        print("selected \(card.id)")
        
        if levelType == .bonus2 {
            if let selected = cardsToSelect.popLast() {
                if selected.id == card.id {
                    card.switchTexture(toFront: true)
                    self.displayPoints([card.position], points: 50, upgradeMulti: 1)
                    if cardsToSelect.count == 0 {
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
            return
        }
        
        if selectedCardId == -1 { // selected card is first card
            card.switchTexture(toFront: true)
            selectedCardId = card.id
        } else { // selected card is 2nd card
            self.childInteractions(enabled: false)
            if card.id == selectedCardId { // selected cards match
                gameData.chainMulti += 1
                card.switchTexture(toFront: true)
                if let selectedCards = self.cards[card.id] {
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
                        self.cards.removeValue(forKey: card.id)
                        self.childInteractions(enabled: true)
                        if (self.cards.values.count <= 1) {
                            self.autoEndLevel()
                        }
                    }
                }
                selectedCardId = -1
            } else { // selected cards don't match
                gameData.chainMulti = 0
                if levelType == .normal {
                    card.switchTexture(toFront: true)
                    gameData.updateLife(by: -1)
                    self.gameNode.run(afterDelay: 1) {
                        if self.gameData.life >= 0 {
                            card.invalidateUpgrade()
                            card.switchTexture(toFront: false)
                            if let selectedCards = self.cards[self.selectedCardId] {
                                for card2 in selectedCards {
                                    if card2.faceUp {
                                        card2.invalidateUpgrade()
                                        card2.switchTexture(toFront: false)
                                    }
                                }
                            }
                            self.selectedCardId = -1
                            if self.gameData.life >= 0 {
                                self.childInteractions(enabled: true)
                            }
                        } else {
                            self.gameOver()
                        }
                        
                    }
                } else { // bonus level
                    for card in allCards {
                        if !card.faceUp {
                            card.switchTexture(toFront: true)
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
        var points = points
        let pointsEachCard = points/pos.count
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
            if gameData.chainMulti > 1 {
                points += pointsEachCard * gameData.chainMulti * upgradeMulti
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
