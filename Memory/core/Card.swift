//
//  Card.swift
//  Memory
//
//  Created by Puja Dialehabady on 22.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Card: ActionNode {
    
    //var delegate: CardDelegate?
    var faceUp = false
    let id: Int
    var frontTexture: SKTexture?
    var upgrade: Upgrade?
    var originalSize : CGSize!
    init(id: Int, imageNamed image: String, _ delegate: CardDelegate) {
        self.id = id
        //self.delegate = delegate
        self.frontTexture = SKTexture(imageNamed: image)
        super.init(texture: Constants.cardBackTexture)
        self.originalSize = self.size
        self.isUserInteractionEnabled = false
        self.setScale(0)
        action = {
            delegate.didSelectCard(self)
        }
    }
    
    func switchTexture(toFront front: Bool) {
        self.isUserInteractionEnabled = false
        self.setScale(1.0)
        self.run(SKAction.sequence([
            SKAction.run {
                if self.upgrade != nil {
                    self.upgrade!.removeFromParent()
                }
            },
            SKAction.scaleX(to: 0, duration: 0.15),
            SKAction.run {
                self.texture = front ? self.frontTexture! : Constants.cardBackTexture
                
            },
            SKAction.run {
                if self.upgrade != nil {
                    self.addChild(self.upgrade!)
                }
            },
            SKAction.scaleX(to: 1.0, duration: 0.15),
            SKAction.run {
                self.faceUp = front ? true : false
                if self.upgrade != nil && self.upgrade!.invalid {
                    self.upgrade!.run(SKAction.sequence([
                        SKAction.scale(to: 1.1, duration: 0.1),
                        SKAction.scale(to: 0, duration: 0.15),
                        SKAction.run({
                            self.upgrade!.removeFromParent()
                            self.upgrade = nil
                        })
                        ]))
                }
                if !self.faceUp {
                    self.isUserInteractionEnabled = true
                }
            }
            ]))
    }
    
    func removeFromParentAnimated() {
        self.isUserInteractionEnabled = false
        self.removeAllActions()
        self.run(SKAction.sequence([
            SKAction.scale(to: 0.0, duration: 0.15),
            SKAction.run({
                self.removeFromParent()
            })
            ]))
    }
    
    func addUpgrade(_ type: UpgradeType) {
        upgrade = Upgrade(type: type)
        upgrade?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        upgrade!.position = CGPoint(x: self.originalSize.width/2 - upgrade!.size.width/2 + upgrade!.dx, y: self.originalSize.height/2 - upgrade!.size.height/2 + upgrade!.dy)
        self.addChild(upgrade!)
    }
    
    func hasUpgrade() -> Bool {
        return upgrade != nil && !upgrade!.invalid
    }
    
    func invalidateUpgrade() {
        if hasUpgrade() {
            upgrade?.invalid = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
