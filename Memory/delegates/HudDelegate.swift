//
//  GameDataDelegate.swift
//  Memory
//
//  Created by Puja Dialehabady on 30.04.18.
//  Copyright © 2018 puja. All rights reserved.
//
import Foundation

protocol HudDelegate {
    
    func changedLife(to life: Int)
    func changedScore(to score: Int, _ highScore: Bool)
    func changedLevel(to level: Int)
    func didStartNewGame()
    //func didLoadGameData()
}
