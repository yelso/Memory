//
//  CardData.swift
//  Memory
//
//  Created by Puja Dialehabady on 28.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation

struct CardsData: Codable {
    
    var cards: [CardData]
    
    func getCardDataWithId(_ id: Int) -> CardData? {
        for card in cards {
            if card.id == id {
                return card
            }
        }
        return nil
    }
}

struct CardData: Codable {
    
    var id: Int
    var name: String
}
