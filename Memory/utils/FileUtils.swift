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
}
