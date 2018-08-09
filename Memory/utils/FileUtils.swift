//
//  FileUtils.swift
//  Memory
//
//  Created by Puja Dialehabady on 28.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation

class FileUtils {
    
    static func loadCards(named name: String) -> CardsData? {
        var path = Bundle.main.path(forResource: name, ofType: "json")
        if path == nil {
            path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name + ".json", isDirectory: false).path
        }
        if path != nil {
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
            let decoder = JSONDecoder()
            var cardsData: CardsData?
            do {
                try cardsData = decoder.decode(CardsData.self, from: jsonData!)
            } catch let error {
                fatalError(error.localizedDescription)
            }
            
            return cardsData!
        } else {
        }
        return nil
    }
    
    static func loadCardSets(named name: String) -> CardSets? {
        var path = Bundle.main.path(forResource: name, ofType: "json")
        if path == nil {
            path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name + ".json", isDirectory: false).path
        }
        if path != nil {
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
            let decoder = JSONDecoder()
            var cardSets: CardSets?
            do {
                try cardSets = decoder.decode(CardSets.self, from: jsonData!)
            } catch let error {
                fatalError(error.localizedDescription)
            }
            
            return cardSets!
        } else {
        }
        return nil
    }
    
    static func loadLevelData() -> LevelsData? {
        var path = Bundle.main.path(forResource: "LevelData", ofType: "json")
        if path == nil {
            path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("LevelData.json", isDirectory: false).path
        }
        if path != nil {
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
            let decoder = JSONDecoder()
            var levelsData: LevelsData?
            do {
                try levelsData = decoder.decode(LevelsData.self, from: jsonData!)
            } catch let error {
                fatalError(error.localizedDescription)
            }
            
            return levelsData!
        } else {
        }
        return nil
    }
 
    static func save<T: Codable>(_ object: T) -> Bool {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("game_data.json", isDirectory: false)
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            return FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            
        } catch {
            fatalError(error.localizedDescription)
        }
        return false
    }
}
