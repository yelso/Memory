//
//  Extensions.swift
//  Memory
//
//  Created by Puja Dialehabady on 22.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

extension UIColor {
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}

extension SKSpriteNode {
    
    func shake(delayed delay: TimeInterval) {
        self.run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.moveBy(x: 5, y: 0, duration: 0.04), SKAction.moveBy(x: -10, y: 0, duration: 0.08), SKAction.moveBy(x: 10, y: 0, duration: 0.08), SKAction.moveBy(x: -10, y: 0, duration: 0.08), SKAction.moveBy(x: 5, y: 0, duration: 0.04)]))
    }
    
    func shake() {
        self.run(SKAction.sequence([SKAction.moveBy(x: 5, y: 0, duration: 0.04), SKAction.moveBy(x: -10, y: 0, duration: 0.08), SKAction.moveBy(x: 10, y: 0, duration: 0.08), SKAction.moveBy(x: -10, y: 0, duration: 0.08), SKAction.moveBy(x: 5, y: 0, duration: 0.04)]))
    }
    
    func run(afterDelay delay: TimeInterval, _ runBlock: @escaping () -> Void) {
        self.run(SKAction.afterDelay(delay, runBlock: runBlock))
    }
}

extension SKLabelNode {
    
    func addStroke(color:UIColor, width: CGFloat) {
        
        guard let labelText = self.text else { return }
        
        let font = UIFont(name: self.fontName!, size: self.fontSize)
        
        let attributedString:NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        let attributes:[NSAttributedStringKey:Any] = [.strokeColor: color, .strokeWidth: -width, .font: font!, .foregroundColor: self.fontColor!]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    func run(afterDelay delay: TimeInterval, _ runBlock: @escaping () -> Void) {
        self.run(SKAction.afterDelay(delay, runBlock: runBlock))
    }
}

extension SKAction {
    /**
     * Performs an action after the specified delay.
     */
    class func afterDelay(_ delay: TimeInterval, performAction action: SKAction) -> SKAction {
        return SKAction.sequence([SKAction.wait(forDuration: delay), action])
    }
    /**
     * Performs a block after the specified delay.
     */
    class func afterDelay(_ delay: TimeInterval, runBlock block: @escaping () -> Void) -> SKAction {
        return SKAction.afterDelay(delay, performAction: SKAction.run(block))
    }
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}
