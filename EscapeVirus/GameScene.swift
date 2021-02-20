//
//  GameScene.swift
//  EscapeVirus
//
//  Created by nr on 1/16/21.
//  Copyright © 2021 Girls who code. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var leftHuman = SKSpriteNode()
    var rightHuman = SKSpriteNode()
    
    var canMove = false
    var leftHumanToMoveLeft = true
    var rightHumanToMoveRight = true
    
    var leftHumanAtRight = false
    var rightHumanAtLeft = false
    var centerPoint : CGFloat!
    var score = 0
    
    let leftHumanMinimumX :CGFloat = -280
    let leftHumanMaximumX : CGFloat = -80
    
    let rightHumanMinimumX :CGFloat = 80
    let rightHumanMaximumX :CGFloat = 280
    
    
    var countDown = 1
    var stopEverything = true
    var scoreText = SKLabelNode()
    
    var gameSettings = Settings.sharedInstance
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        physicsWorld.contactDelegate = self
        createRoadStrip()
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector
            (GameScene.createRoadStrip), userInfo: nil , repeats: true);
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector
            (GameScene.startCountDown), userInfo: nil , repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumbers (firstNumber: 1, secondNumber: 10)), target: self, selector: #selector(GameScene.leftTraffic), userInfo: nil , repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumbers (firstNumber: 1, secondNumber: 10)), target: self, selector: #selector(GameScene.rightTraffic), userInfo: nil , repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector
            (GameScene.removeItems), userInfo: nil , repeats: true);
        let deadTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadTime) {
            Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector
                (GameScene.increaseScore), userInfo: nil , repeats: true)
            
        }
    
    }
    override func update(_ currentTime: TimeInterval) {
        if canMove{
            move(leftSide:leftHumanToMoveLeft)
            moveRightHuman(rightSide: rightHumanToMoveRight)
        }
        showRoadStrip()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "leftHuman" || contact.bodyA.node?.name == "rightHuman"{firstBody = contact.bodyA
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        firstBody.node?.removeFromParent()
        afterCollision()
    }

    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if touchLocation.x > centerPoint{
                if rightHumanAtLeft{
                    rightHumanAtLeft = false
                    rightHumanToMoveRight = true
                }else{
                    rightHumanAtLeft = true
                    rightHumanToMoveRight = false
                }
                
            }else{
                if leftHumanAtRight{
                    leftHumanAtRight = false
                    leftHumanToMoveLeft = true
                }else{
                    leftHumanAtRight = true
                    leftHumanToMoveLeft = false
                }
            }
            canMove = true;
        }
    }
    
    func setUp() {
        leftHuman = self.childNode(withName: "leftHuman") as! SKSpriteNode
        rightHuman = self.childNode(withName: "rightHuman") as! SKSpriteNode
        centerPoint = self.frame.size.width / self.frame.size.height
        
        leftHuman.physicsBody?.categoryBitMask = ColliderType.HUMAN_COLLIDER
        leftHuman.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        leftHuman.physicsBody?.collisionBitMask = 0
        
        rightHuman.physicsBody?.categoryBitMask = ColliderType.HUMAN_COLLIDER
        rightHuman.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER_1
        rightHuman.physicsBody?.collisionBitMask = 0
        
        let scoreBackGround = SKShapeNode(rect:CGRect(x:-self.size.width/2 + 30 ,y:self.size.height/2 - 130 ,width:180,height:80), cornerRadius: 20)
        scoreBackGround.zPosition = 10
        scoreBackGround.fillColor = SKColor.black.withAlphaComponent(0.3)
        scoreBackGround.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(scoreBackGround)
        
        scoreText.name = "score"
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.text = "0"
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: -self.size.width/2 + 120, y: self.size.height/2 - 110)
        scoreText.fontSize = 50
        scoreText.zPosition = 10
        addChild(scoreText)
        
        
    }

    @objc func createRoadStrip(){
        let leftRoadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        leftRoadStrip.strokeColor = SKColor.white
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.alpha = 0.4
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.zPosition = 10
        leftRoadStrip.position.x = -187.5
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)
        
        let rightRoadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        rightRoadStrip.strokeColor = SKColor.white
        rightRoadStrip.fillColor = SKColor.white
        rightRoadStrip.alpha = 0.4
        rightRoadStrip.name = "rightRoadStrip"
        rightRoadStrip.zPosition = 10
        rightRoadStrip.position.x = 187.5
        rightRoadStrip.position.y = 700
        addChild(rightRoadStrip)

    }
    
    func showRoadStrip(){
        enumerateChildNodes(withName: "leftRoadStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        })
        enumerateChildNodes(withName: "rightRoadStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        })
        enumerateChildNodes(withName: "Virus1", using: { (leftHuman, stop) in
            let human = leftHuman as! SKSpriteNode
            human.position.y -= 15
        })
        enumerateChildNodes(withName: "Virus2", using: { (rightHuman, stop) in
            let human = rightHuman as! SKSpriteNode
            human.position.y -= 15
        })
    }
    
    @objc func removeItems(){
        for child in children{
            if child.position.y < -self.size.height - 100{
                child.removeFromParent()
            }
        }
    }
    
    func move(leftSide:Bool){
        if leftSide{
            leftHuman.position.x -= 20
            if leftHuman.position.x < leftHumanMinimumX{
                leftHuman.position.x = leftHumanMinimumX
            }
        }else{
            leftHuman.position.x += 20
            if leftHuman.position.x > leftHumanMaximumX{
                leftHuman.position.x = leftHumanMaximumX
            }
      
        }
    }

    func moveRightHuman(rightSide:Bool){
        if rightSide{
            rightHuman.position.x += 20
            if rightHuman.position.x > rightHumanMaximumX{
                rightHuman.position.x = rightHumanMaximumX
            }
        }else{
            rightHuman.position.x -= 20
            if rightHuman.position.x < rightHumanMinimumX{
                rightHuman.position.x = rightHumanMinimumX
            }
        }
    }

    
    @objc func leftTraffic(){
        if !stopEverything{
        let leftTrafficItem : SKSpriteNode!
        let randomNumber = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 8)
        switch Int(randomNumber) {
        case 1...4:
            leftTrafficItem = SKSpriteNode(imageNamed: "Virus1")
            leftTrafficItem.name = "Virus1"
            break
        case 5...8:
            leftTrafficItem = SKSpriteNode(imageNamed: "Virus2")
            leftTrafficItem.name = "Virus2"
            break
        default:
            leftTrafficItem = SKSpriteNode(imageNamed: "Virus1")
            leftTrafficItem.name = "Virus1"
            }
        leftTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftTrafficItem.zPosition = 10
        let randomNum = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 10)
        switch Int(randomNum) {
        case 1...4:
            leftTrafficItem.position.x = -280
            break
        case 5...10:
            leftTrafficItem.position.x = -100
            break
        default:
            leftTrafficItem.position.x = -280
        }
        leftTrafficItem.position.y = 700
        leftTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: leftTrafficItem.size.height/2)
        leftTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        leftTrafficItem.physicsBody?.collisionBitMask = 0
        leftTrafficItem.physicsBody?.affectedByGravity = false
        addChild(leftTrafficItem)
        }
        }

    @objc func rightTraffic(){
        if !stopEverything{
        let rightTrafficItem : SKSpriteNode!
        let randomNumber = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 8)
        switch Int(randomNumber) {
        case 1...4:
            rightTrafficItem = SKSpriteNode(imageNamed: "Virus1")
            rightTrafficItem.name = "Virus1"
            break
        case 5...8:
            rightTrafficItem = SKSpriteNode(imageNamed: "Virus2")
            rightTrafficItem.name = "Virus2"
            break
        default:
            rightTrafficItem = SKSpriteNode(imageNamed: "Virus1")
            rightTrafficItem.name = "Virus1"
        }
        rightTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rightTrafficItem.zPosition = 10
        let randomNum = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 10)
        switch Int(randomNum) {
        case 1...4:
            rightTrafficItem.position.x = 280
            break
        case 5...10:
            rightTrafficItem.position.x = 100
            break
        default:
            rightTrafficItem.position.x = 280
        }
        rightTrafficItem.position.y = 700
        rightTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: rightTrafficItem.size.height/2)
        rightTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER_1
        rightTrafficItem.physicsBody?.collisionBitMask = 0
        rightTrafficItem.physicsBody?.affectedByGravity = false
        
        addChild(rightTrafficItem)
        }
    }

    func afterCollision(){
        if gameSettings.highScore < score{
            gameSettings.highScore = score
        }
        gameSettings.highScore = score
        let menuScene = SKScene(fileNamed: "GameMenu")!
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
    }
    
    
    @objc func startCountDown(){
        if countDown>0{
            if countDown < 4{
                let countDownLabel = SKLabelNode()
                countDownLabel.fontName = "AvenirNext-Bold"
                countDownLabel.fontColor = SKColor.white
                countDownLabel.fontSize = 300
                countDownLabel.text = String(countDown)
                countDownLabel.position = CGPoint(x: 0, y: 0)
                countDownLabel.zPosition = 300
                countDownLabel.name = "cLabel"
                countDownLabel.horizontalAlignmentMode = .center
                addChild(countDownLabel)
                
                let deadTime = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: deadTime, execute: {
                countDownLabel.removeFromParent()
            })
        }
            countDown += 1
            if countDown == 4 {
                self.stopEverything = false
            }
    }
    }

    @objc func increaseScore(){
        if !stopEverything{
            score += 1
            scoreText.text = String(score)
            
        }
    }

}
