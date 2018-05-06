//
//  GameDataDelegate.swift
//  Memory
//
//  Created by Puja Dialehabady on 30.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation

protocol GameDataDelegate {
    
    func changedLife(to life: Int)
    func changedScore(to score: Int)
    func changedLevel(to level: Int)
    func didStartNewGame()
}
