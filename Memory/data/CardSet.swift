//
//  CardSet.swift
//  Memory
//
//  Created by Puja Dialehabady on 26.06.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation

struct CardSets: Codable {
    
    var sets: [CardSet]
    
    func getCardSetsWithDifficulty(_ difficulty: Int) -> [CardSet] {
        var cardSets = [CardSet]()
        for set in sets {
            if set.difficulty == difficulty {
                cardSets.append(set)
            }
        }
        return cardSets
    }
    
    func getCardSetWithId(_ id: Int) -> CardSet? {
        for set in sets {
            if set.id == id {
                return set
            }
        }
        return nil
    }
    
}

struct CardSet: Codable {
    
    var id: Int
    var difficulty: Int
    var cards: [Int]
}
