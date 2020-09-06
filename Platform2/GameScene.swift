//
//  GameScene.swift
//  Platform2
//
//  Created by C C on 05/09/2020.
//  Copyright © 2020 C C. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var cameraNode: SKCameraNode!
    var player: SKNode!
    var movingWall: SKNode!
    var thrustSmoke: SKEmitterNode!
    var thrusts = [SKEmitterNode]()
    var coinTextures: [SKTexture] = []
    var coinAnimation: SKAction!
    
    override func didMove(to view: SKView) {
        
              
        prepareCoinAnimation()
        prepareSprites()
        addSmokeToPlayer()
        prepareCamera()
        
        
        
    }
    
    func prepareSprites(){
        for child in self.children{
            
            if child.name == "redSquare" {
                player = child
                let leftEye = SKSpriteNode(color: .yellow, size: CGSize(width: 15, height: 15))
     
                let blinkEye = SKSpriteNode(color: .black, size: CGSize(width: 20, height: 10))
                let blink = SKAction.fadeIn(withDuration: 0.5)
                let openEye = SKAction.fadeOut(withDuration:0.1)
                let eyeSequence = SKAction.sequence([blink,openEye])
                
                leftEye.position = CGPoint(x: 0, y: 30)
                //leftEye.addChild(blinkEye)
                leftEye.run(SKAction.repeatForever(eyeSequence))
                //blinkEye.run(SKAction.repeatForever(eyeSequence))
                
                
                
                let rightEye = leftEye.copy() as! SKSpriteNode
                rightEye.position = CGPoint(x: 30, y: 30)

                
                
                player.physicsBody?.allowsRotation = false
                player.addChild(rightEye)
                player.addChild(leftEye)
                
                
                
            } else if child.name == "movingWall" {
                
                self.movingWall  = child
                let moveAmount = CGFloat.random(in: 100...500)
                let moveUp = SKAction.moveBy(x: 0, y:moveAmount ,duration: 2)
                let moveDown = SKAction.moveBy(x: 0, y: -moveAmount, duration: 2)
                let sequence = SKAction.sequence([moveUp, moveDown])
                self.movingWall.run(SKAction.repeatForever(sequence))
                
            } else if child.name == "coin"{
            let coinSprite = child as! SKSpriteNode
                coinSprite.run(coinAnimation)
                coinSprite.physicsBody = SKPhysicsBody(circleOfRadius: 20)
                coinSprite.physicsBody!.affectedByGravity = false
                coinSprite.physicsBody!.isDynamic = false
                coinSprite.physicsBody!.allowsRotation = false
//                coinSprite.physicsBody!.contactTestBitMask = 0b0001
                
                
            } else {
                child.physicsBody?.contactTestBitMask = 0b0010
            }
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "redSquare" || contact.bodyB.node?.name == "coin" {
            // execute code to respond to object hitting ground
//            contact.bodyB.node?.removeFromParent()
  print("CONTACT!!! ")
        
        }
    }
    
    func addSmokeToPlayer(){
        thrustSmoke = SKEmitterNode(fileNamed: "Thrust.sks")
        thrustSmoke.targetNode = self
        thrustSmoke.isHidden = true
        player.zPosition  = 10
        thrustSmoke.zPosition = 5
        player.addChild(thrustSmoke)
    }
    
    
    
    func prepareCamera(){
        cameraNode = SKCameraNode()
        addChild(cameraNode)
        camera = cameraNode
        camera?.position = player.position
        
    }
    
    
    
    
    func prepareCoinAnimation() {
        for i in 0...4{
            coinTextures.append(SKTexture(imageNamed: "coin\(i).png"))
        }
        
        for i in stride(from: 1, to: 3, by: -1) {
            coinTextures.append(SKTexture(imageNamed: "coin\(i).png"))
        }
        let aRotation = SKAction.animate(with: coinTextures, timePerFrame: 0.1)
       
        let sequence = SKAction.sequence([aRotation])
        coinAnimation = SKAction.repeatForever(sequence)
        
    }
    
    
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)

    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        cameraNode.position = player.position
    }
    
    
    
    
    fileprivate func handleTouch(_ touches: Set<UITouch>) {
        let touch = touches.first
        let position = touch?.location(in: self) as! CGPoint
        let deltaX = player.position.x - position.x
        if deltaX < 0 {
            player.physicsBody?.applyImpulse(CGVector(dx: -75, dy: 80))
            thrustSmoke.emissionAngle = -30
            
        } else {
            thrustSmoke.emissionAngle = 30
            player.physicsBody?.applyImpulse(CGVector(dx: 75, dy: 80))
            
        }
    }
    
    
    
    
    
}

