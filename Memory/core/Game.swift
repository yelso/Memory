//
//  Game.swift
//  Memory
//
//  Created by Puja Dialehabady on 22.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import SpriteKit

public class Game /* : CardDelegate*/ {
    /*
    var count = 0
    var cards = [Int: [Card]]()
    var selectedCardId = -1
    var selectedColor : UIColor?
    var selectedCard: ActionNode?
    var node: SKSpriteNode!
    var flippedCardCount = 0
    var multi = 2
    var cardData : [CardData]?
    
    //var levels: Level

    var score: Int = 0
    var level: Int = 0
    var lifes: Int = 0
    var lifeCounter: Int = 0
    var additionalLife: Int = 0
    var cardsLeftList = [ActionNode]()
    
    // matrix
    var width: Int?
    var height: Int?
    
    init() {
        //levels = Level(CGSize(width: 300, height: 600))
        // TODO
        /*self.level = 0
        self.score = 0
        self.lifes = 0
        self.lifeCounter = 1
        self.additionalLife = 1
        node = SKSpriteNode(color: .clear, size: CGSize(width: 375, height: 800))
        //node.color = .green
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let cardsData = FileUtils.loadCards(named: "cards1")
        cardData = cardsData!.cards */
    }
    
    func loadGame() {
        // TODO
    }
    
    func nextLevel() {
        /*
        // TODO
        self.level += 1
        self.lifes += additionalLife
        self.lifeCounter -= 1
        print("level: \(level) lifes: \(lifes) addLife: \(additionalLife) lifeCount: \(lifeCounter)")
        if self.lifeCounter <= 0 {
            self.additionalLife += 1
            self.lifeCounter = level == 1 ? 2 : level
        }
        print("addLife: \(additionalLife) counter: \(lifeCounter)")
        createMatrixAndPlaceCards()
 */
    }
    
    func createMatrixAndPlaceCards() {
        let matrixSize = getSizeForLevel()
        let size = 50
        var cardList = [Card]()
        var matrix = [[ActionNode]](repeating: [ActionNode](repeating: ActionNode(color: .clear, size: CGSize(width: 1, height: 1)), count: matrixSize.columns), count: matrixSize.rows)
        for index in 0..<((matrixSize.rows * matrixSize.columns)/2) {
            
            let card1 = Card(id: index + 1, imageNamed: cardData![index%6].name, self)
            let card2 = Card(id: index + 1, imageNamed: cardData![index%6].name, self)

            cards[index + 1] = [card1, card2]
            
            cardList.append(card1)
            cardList.append(card2)
        }
        count = cards.count
        cardList.shuffle()
        
        let spacer = 10
        
        let maxWidth = matrixSize.columns * size + (matrixSize.columns-1) * spacer
        let mHeight = matrixSize.rows * size + (matrixSize.rows-1) * spacer
        
        for row in 0..<matrixSize.rows {
            for column in 0..<matrixSize.columns {
                let card = cardList.popLast()!
                let x = (maxWidth/2 * -1) + (column * size) + (column * spacer) + (size/2)
                let y = (mHeight/2 - size/2) - (row * size) - (row * spacer)
                card.position = CGPoint(x: x, y: y)
                //print("x: \(x) y: \(y)")
                matrix[row][column] = card
                node.addChild(card)
            }
        }
        
        node.children.forEach { (node) in
            node.run(SKAction.sequence([
                SKAction.scale(to: 1.0, duration: 0.2),
                SKAction.run({
                    node.isUserInteractionEnabled = true
                })
                ]))
        }
    }
    
    func autoEndLevel() {
        // last two left card disapear automaticly
        
        for card in self.cards.values {
            card[0].switchTexture(true)
            card[1].switchTexture(true)
        }
        for card in self.cards.values {
            displayPoints(card[0].position)
            displayPoints(card[1].position)
        }
        
        self.node.run(SKAction.afterDelay(2, runBlock: {
            for card in self.cards.values {
                card[0].removeFromParentAnimated()
                card[1].removeFromParentAnimated()
            }
            self.node.run(SKAction.afterDelay(0.2, runBlock: {
                self.cards.removeAll()
                self.nextLevel()
            }))
        }))
    }
    
    func getSizeForLevel() -> (rows: Int, columns: Int) {
        switch level {
        case 1:
            return (rows: 2, columns: 2)
        case 2:
            return (rows: 2, columns: 3)
        case 3:
            return (rows: 4, columns: 3)
        default:
            return (rows: 4, columns: 4)
        }
    }
    
    func gameOver() {
        selectedCardId = -1
        self.cards.removeAll()
        self.score = 0
        self.level = 0
        self.lifes = 0
        self.lifeCounter = 1
        self.additionalLife = 1
        self.nextLevel()
    }
    
    func didSelectCard(_ card: Card) {
        print("selected \(card.id)")
        if selectedCardId == -1 { // selected card is first card
            card.switchTexture(true)
            selectedCardId = card.id
        } else { // selected card is 2nd card
            self.childInteractions(enabled: false)
            if card.id == selectedCardId { // selected cards match
                
                //self.score += 100
                card.switchTexture(true)
                if let selectedCards = self.cards[card.id] {
                    for card2 in selectedCards {
                        self.displayPoints(card2.position)
                    }
                }
                
                //remove matched cards from cards
                self.node.run(afterDelay: 1) {
                    if let selectedCards = self.cards[card.id] {
                        for card2 in selectedCards {
                            card2.removeFromParentAnimated()
                        }
                    }
                    self.cards.removeValue(forKey: card.id)
                    self.childInteractions(enabled: true)
                    if (self.cards.values.count <= 1) {
                        self.autoEndLevel()
                    }
                }
                selectedCardId = -1
            } else { // selected cards don't match
                card.switchTexture(true)
                self.lifes -= 1
                print("wrong \(self.lifes)")
                self.node.run(afterDelay: 1) {
                    card.switchTexture(false)
                    if let selectedCards = self.cards[self.selectedCardId] {
                        for card2 in selectedCards {
                            if card2.faceUp {
                                card2.switchTexture(false)
                            }
                        }
                    }
                    self.selectedCardId = -1
                    if self.lifes >= 0 {
                        self.childInteractions(enabled: true)
                    }
                }
                if self.lifes < 0 { // player loses
                    print("game over score: \(self.score)")
                    self.node.run(afterDelay: 2) {
                        self.node.removeAllChildren()
                        self.gameOver()
                    }
                }
            }
        }
    }
    
    func childInteractions(enabled: Bool) {
        self.node.children.forEach({ (node) in
            node.isUserInteractionEnabled = enabled
        })
    }
    
    func displayPoints(_ pos: CGPoint) {
        var points = 5
        let pointsLabel = SKLabelNode(text: "5")
        pointsLabel.fontSize = 24
        pointsLabel.fontName = "Marker Felt"
        pointsLabel.fontColor = UIColor(red:0.97, green:0.72, blue:0.19, alpha:1.0)
        let pointsNode = SKSpriteNode(color: .clear, size: CGSize(width: pointsLabel.frame.size.width, height: pointsLabel.frame.size.height))
        pointsNode.addChild(pointsLabel)
        pointsLabel.horizontalAlignmentMode = .center
        pointsLabel.verticalAlignmentMode = .center
        pointsLabel.addStroke(color: .black, width: 5)
        if multi > 1 {
            points *= multi
            let multiLabel = SKLabelNode(text: "x\(multi)")
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
        
        pointsNode.position = CGPoint(x: pos.x + 20, y: pos.y + 10)
        pointsNode.setScale(0)
        self.node.addChild(pointsNode)
        let scaleUp = SKAction.scale(to: 1, duration: 0.2)
        let moveUp = SKAction.moveBy(x: 0, y: 70, duration: 1.4)
        
        pointsNode.run(SKAction.group([
            scaleUp, moveUp,
            SKAction.afterDelay(1.4, runBlock: {
                pointsNode.removeFromParent()
                self.score += points
            })
        ]))
    }
    */
}

extension SKSpriteNode {
    
    func run(afterDelay delay: TimeInterval, _ runBlock: @escaping () -> Void) {
        self.run(SKAction.afterDelay(delay, runBlock: runBlock))
    }
}

extension SKLabelNode {
    func run(afterDelay delay: TimeInterval, _ runBlock: @escaping () -> Void) {
        self.run(SKAction.afterDelay(delay, runBlock: runBlock))
    }
}
