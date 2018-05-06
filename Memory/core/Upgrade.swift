//
//  Upgrade.swift
//  Memory
//
//  Created by Puja Dialehabady on 29.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import SpriteKit

class Upgrade : SKSpriteNode {
    
    let type: UpgradeType
    var dx: CGFloat = 0
    var dy: CGFloat = 0
    var invalid = false
    
    init(type: UpgradeType) {
        self.type = type
        if type == .life {
            let texture = SKTexture(imageNamed: type.rawValue)
            super.init(texture: texture, color: .clear, size: texture.size())
            dx = self.size.width/2 - 5
            dy = self.size.height/2 - 5
            if let particles = SKEmitterNode(fileNamed: "HeartUpgradeParticle") {
                particles.position = self.position
                particles.particlePositionRange = CGVector(dx: self.size.width, dy: self.size.height)
                particles.particleScale = Constants.multiParticleScale
                particles.zPosition = -1
                self.addChild(particles)
            }
        } else {
            super.init(texture: nil, color: .clear, size: CGSize(width: 50, height: 50))
            let text = SKLabelNode(text: type.rawValue)
            text.fontName = Constants.scoreFontName
            text.fontSize = Constants.upgradeFontSize
            text.verticalAlignmentMode = .center
            text.horizontalAlignmentMode = .center
            if type == .multiplier2 {
                text.fontColor = UIColor(red:0.38, green:0.94, blue:0.97, alpha:1.0)
                text.addStroke(color: UIColor(red:0.02, green:0.02, blue:0.59, alpha:1.0), width: 5)
                if let particles = SKEmitterNode(fileNamed: "Multiplier2UpgradeParticle") {
                    particles.position = self.position
                    particles.particlePositionRange = CGVector(dx: text.frame.width, dy: text.frame.height)
                    particles.particleScale = Constants.multiParticleScale
                    particles.zPosition = -1
                    self.addChild(particles)
                }
            } else {
                text.fontColor = UIColor(red:0.95, green:0.91, blue:0.27, alpha:1.0)
                text.addStroke(color: UIColor(red:0.90, green:0.00, blue:1.00, alpha:1.0), width: 5)
                if let particles = SKEmitterNode(fileNamed: "Multiplier5UpgradeParticle") {
                    particles.position = self.position
                    particles.particlePositionRange = CGVector(dx: text.frame.width, dy: text.frame.height)
                    particles.particleScale = Constants.multiParticleScale
                    particles.zPosition = -1
                    self.addChild(particles)
                }
            }
            dx = self.size.width/2 - 10
            dy = self.size.height/2 - 10
            self.size = text.frame.size
            self.addChild(text)
        }
    }
    
    func getUpgradeAmount() -> Int {
        switch type {
        case .life:
            return 1
        case .multiplier2:
            return 2
        case .multiplier5:
            return 5
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum UpgradeType : String {
    case life = "upgradeLife"
    case multiplier2 = "x2"
    case multiplier5 = "x5"
}
