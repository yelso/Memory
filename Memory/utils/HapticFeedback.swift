//
//  HapticFeedback.swift
//  Memory
//
//  Created by Puja Dialehabady on 22.04.18.
//  Copyright © 2018 puja. All rights reserved.
//

import Foundation
import UIKit

class HapticFeedback {
    // TODO check whether haptic feedback is disabled or not
    
    static let impact = UIImpactFeedbackGenerator(style: .light)
    static let selection = UISelectionFeedbackGenerator()
    static let feedback = UINotificationFeedbackGenerator()
    
    static func success() {
        feedback.notificationOccurred(.success)
    }
    
    static func error() {
        feedback.notificationOccurred(.error)
    }
    
    static func warning() {
        feedback.notificationOccurred(.warning)
    }
    
    static func defaultFeedback() {
        selection.selectionChanged()
    }
    
    static func lightFeedback() {
        impact.impactOccurred()
    }
}
