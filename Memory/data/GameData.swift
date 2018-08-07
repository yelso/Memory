//
//  GameData.swift
//  Memory
//
//  Created by Puja Dialehabady on 07.08.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation

struct GamesData: Codable {
    
    var gameData: GameData

}

struct GameData: Codable {
    
    var valid: Bool
    var level: Int
    var matrixIndex: Int
    var gameOver: Bool
    var life: Int
    var score: Int
    var lifeEachLevel: Int
    var maxChain: Int
    var upgradeMutli: Int
    var chainMulti: Int
    var lifeCounter: Int
}
