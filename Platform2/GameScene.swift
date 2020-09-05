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
    override func didMove(to view: SKView) {
        
        for child in self.children{
            if child.name == "redSquare" {
                player = child
            } else if child.name == "movingWall" {
                
                self.movingWall  = child
                let moveAmount = CGFloat.random(in: 100...200)
                let moveUp = SKAction.moveBy(x: 0, y:moveAmount ,duration: 2)
                let moveDown = SKAction.moveBy(x: 0, y: -moveAmount, duration: 2)
                let sequence = SKAction.sequence([moveUp, moveDown])
                self.movingWall.run(SKAction.repeatForever(sequence))
                
            }
           }
        
         thrustSmoke = SKEmitterNode(fileNamed: "Thrust.sks")
        thrustSmoke.targetNode = self
        player.addChild(thrustSmoke)

        cameraNode = SKCameraNode()
        addChild(cameraNode)
        camera = cameraNode
        camera?.position = player.position
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
   
    
    override func update(_ currentTime: TimeInterval) {
        cameraNode.position = player.position
    }
}

