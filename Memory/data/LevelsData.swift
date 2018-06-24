//
//  LevelData.swift
//  Memory
//
//  Created by Puja Dialehabady on 15.06.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation

struct LevelsData: Codable {
    
    var levels: [LevelData]
    
    func getLevelData(for level: Int) -> LevelData? {
        for levelData in levels.reversed() {
            print("\(levelData.level) + searching for: \(level)")
            if level >= levelData.level {
                return levelData
            }
        }
        return nil
    }

}

struct LevelData: Codable {
    
    var level: Int
    var cards: Int
    var matrix: [[[Int]]]
    
    func getMatrixCount() -> Int{
        return matrix.count
    }
    
    func getRowCountAt(index: Int) -> Int {
        return matrix[index].count
    }
    
    func getColumnCountAt(index: Int) -> Int {
        return matrix[index][0].count
    }
    
    func getMatrixSizeAt(index: Int) -> (rows: Int, columns: Int) {
        return (rows: matrix[index].count, columns: matrix[index][0].count)
    }
    
    func getRandomMatrixIndex() -> Int {
        return Int(arc4random_uniform(UInt32(matrix.count)))
    }
    
}

