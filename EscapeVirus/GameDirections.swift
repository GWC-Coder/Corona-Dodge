//
//  GameDirections.swift
//  EscapeVirus
//
//  Created by nr on 2/20/21.
//  Copyright © 2021 Girls who code. All rights reserved.
//

import Foundation
import SpriteKit

class GameDirections: SKScene{
    
    var startGame = SKLabelNode()

    override func didMove (to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        startGame = self.childNode(withName: "labelStart") as! SKLabelNode
     }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "labelStart"{
                let GameScene = SKScene(fileNamed: "GameScene")!
                GameScene.scaleMode = .aspectFill
                view?.presentScene(GameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
            }
        }
        
    }
}
