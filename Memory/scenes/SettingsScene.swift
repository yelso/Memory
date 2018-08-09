//
//  SettingsScene.swift
//  Memory
//
//  Created by Linda Schrödl on 07.08.18.
//  Copyright © 2018 puja. All rights reserved.
//

import SpriteKit
import GameplayKit

class SettingsScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        //_Background
        let image = UserDefaults.standard.string(forKey: "background")
        let background = SKSpriteNode(imageNamed: image!)
        self.addChild(background)
        
        //_Logo
        let logoView = SKSpriteNode(imageNamed: "Logo_Teufel")
        logoView.position = CGPoint(x: 0, y: 310)
        logoView.size = CGSize(width: 100, height: 100)
        background.addChild(logoView)
        
        //_Text
        let textLabel = SKLabelNode(text: "Hintergrund")
        textLabel.text = "Wähle ein neues Hintergundbild:"
        textLabel.lineBreakMode = NSLineBreakMode.byClipping
        textLabel.numberOfLines = 0
        textLabel.preferredMaxLayoutWidth = 400
        textLabel.fontName = "Helvetica Neue Thick"
        textLabel.fontSize = 22
        textLabel.position = CGPoint(x: 0, y: 220)
        self.addChild(textLabel)
        
        
        //let frameButton = ActionNode(texture: SKTexture(imageNamed: "Rahmen"), color: .black, size: CGSize(width: 125, height: 456))
        //_Button1
        let picOne = SKSpriteNode(imageNamed: "NummerEins")
        picOne.size = CGSize(width: 120 , height: 210)
        let buttonOne = ActionNode(color: .black, size: CGSize(width: 120, height: 210))
        buttonOne.position = CGPoint(x: -85, y: 90)
        buttonOne.addChild(picOne)
        self.addChild(buttonOne)
        
        //_Frame_B1
        let frameButton = SKSpriteNode(imageNamed: "Rahmen2")
        frameButton.size = CGSize(width: 120, height: 210)
        buttonOne.addChild(frameButton)
        
        //_Button2
        let picTwo = SKSpriteNode(imageNamed: "background4")
        picTwo.size = CGSize(width: 120 , height: 210)
        let buttonTwo = ActionNode(color: .black, size: CGSize(width: 120, height: 210))
        buttonTwo.position = CGPoint(x: 85, y: 90)
        buttonTwo.addChild(picTwo)
        self.addChild(buttonTwo)
        
        //_Frame_B2
        let frameButton2 = SKSpriteNode(imageNamed: "Rahmen2")
        frameButton2.size = CGSize(width: 120, height: 210)
        buttonTwo.addChild(frameButton2)
        
        //_Button3
        let picThree = SKSpriteNode(imageNamed: "background5")
        picThree.size = CGSize(width: 120 , height: 210)
        let buttonThree = ActionNode(color: .black, size: CGSize(width: 120, height: 210))
        buttonThree.position = CGPoint(x: -85, y: -165)
        buttonThree.addChild(picThree)
        self.addChild(buttonThree)
        
        //_Frame_B3
        let frameButton3 = SKSpriteNode(imageNamed: "Rahmen2")
        frameButton3.size = CGSize(width: 120, height: 210)
        buttonThree.addChild(frameButton3)
        
        //_Button4
        let picFour = SKSpriteNode(imageNamed: "background")
        picFour.size = CGSize(width: 120 , height: 220)
        let buttonFour = ActionNode(color: .black, size: CGSize(width: 120, height: 210))
        buttonFour.position = CGPoint(x: 85, y: -165)
        buttonFour.addChild(picFour)
        self.addChild(buttonFour)
        
        //_Frame_B3
        let frameButton4 = SKSpriteNode(imageNamed: "Rahmen2")
        frameButton4.size = CGSize(width: 120, height: 210)
        buttonFour.addChild(frameButton4)
        
        //_Button_Back
        let buttonBack = ActionNode(color: .black, size: CGSize(width: 120, height: 40))
        buttonBack.position = CGPoint(x: 0, y: -320)
        let labelButton = SKLabelNode(text: "Zurück")
        labelButton.verticalAlignmentMode = .center
        labelButton.fontName = "Helvetica Neue Thick"
        labelButton.fontSize = 19
        buttonBack.addChild(labelButton)
        self.addChild(buttonBack)
        
        //_Frame_BB
        let frameButtonBack = SKSpriteNode(imageNamed: "Rahmen2")
        frameButtonBack.size = CGSize(width: 120, height: 40)
        buttonBack.addChild(frameButtonBack)
        
        
        buttonBack.action =  {
            let scene = MainMenuScene(size: self.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.isMultipleTouchEnabled = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene, transition: transition)
        }
        
        
        buttonOne.action = {
            background.texture = SKTexture(imageNamed: "NummerEins")
            UserDefaults.standard.set("NummerEins", forKey: "background")
        }
        buttonTwo.action = {
            background.texture = SKTexture(imageNamed: "background4")
            UserDefaults.standard.set("background4", forKey: "background")
        }
        buttonThree.action = {
            background.texture = SKTexture(imageNamed: "background5")
            UserDefaults.standard.set("background5", forKey: "background")
        }
        buttonFour.action = {
            background.texture = SKTexture(imageNamed: "background")
            UserDefaults.standard.set("background", forKey: "background")
        }
        
    }
    
}
