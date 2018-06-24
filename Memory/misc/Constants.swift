//
//  Constants.swift
//  Memory
//
//  Created by Puja Dialehabady on 24.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

struct Constants {
    
    let matrix1 = [[-150, -50, 50, 150]]
    static let cardBackTexture = SKTexture(image: UIImage(named: "cardBack2")!)
    
    static let upgradeFontSize : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 19 : 38
    static let scoreFontName = "Marker Felt"
    static let hudHeight : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 40 : 60
    static let hudFontSize : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 20 : 35
    static let hudBonusFontSize : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 35 : 50
    static let hudBonusExplanationFontSize : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 20 : 35
    static let cardSize: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 50 : 100
    static let multiParticleScale: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 0.1 : 0.3
    static let gameOverTitleFontSize : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 50 : 85
    static let gameOverTextFontSize : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 15 : 36
    static let gameOverValueFontSize : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 48 : 80
}
