//
//  GameMenu.swift
//  EscapeVirus
//
//  Created by nr on 2/7/21.
//  Copyright © 2021 Girls who code. All rights reserved.
//

import Foundation

import SpriteKit

class GameMenu: SKScene{
    
    var startGame = SKLabelNode()
    var bestScore = SKLabelNode()
    var startBanner = SKShapeNode()
    var gameSettings = Settings.sharedInstance
    
    override func didMove (to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        startGame = self.childNode(withName: "startGame") as! SKLabelNode
        startBanner = self.childNode(withName: "startBanner") as! SKShapeNode
        bestScore = self.childNode(withName: "bestScore") as! SKLabelNode
        bestScore.text = ""
        bestScore.text = "Best : \(gameSettings.highScore)"
  }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "startGame"{
                let GameDirections = SKScene(fileNamed: "GameDirections")!
                GameDirections.scaleMode = .aspectFill
                view?.presentScene(GameDirections, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
                
        }
    }
    
  }
}
