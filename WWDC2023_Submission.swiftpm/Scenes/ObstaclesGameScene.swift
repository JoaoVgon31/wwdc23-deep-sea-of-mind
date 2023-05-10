import Foundation
import SwiftUI
import SpriteKit
 
enum ObstacleType: Int {
    case Left = -1
    case Middle
    case Right
}

class ObstaclesGameScene: BasicGameScene {
    var maxObstacles = 5
    var lastObstacleType: ObstacleType = .Middle
    
    func addObstacle() {
        var randomObstacleTypeRawValue: Int = 0
        while randomObstacleTypeRawValue == lastObstacleType.rawValue {
            randomObstacleTypeRawValue = Int.random(in: -1...1)
        }
        guard let randomObstacleType = ObstacleType(rawValue: randomObstacleTypeRawValue) else {
            return
        }
        lastObstacleType = randomObstacleType
        
        if randomObstacleType == .Middle {
            let obstacleLeft = SKSpriteNode(color: UIColor(Color.brown), size: CGSize(width: size.width * 0.30, height: size.height * 0.06))
            let obstacleRight = SKSpriteNode(color: UIColor(Color.brown), size: CGSize(width: size.width * 0.30, height: size.height * 0.06))
            
            obstacleLeft.position = CGPoint(x: -(size.width - obstacleLeft.size.width) / 2, y: -(size.height - obstacleLeft.size.height) / 2 - obstacleLeft.size.height)
            obstacleRight.position = CGPoint(x: (size.width - obstacleRight.size.width) / 2, y: -(size.height - obstacleRight.size.height) / 2 - obstacleRight.size.height)
            
            obstacleLeft.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: obstacleLeft.size.width, height: obstacleLeft.size.height))
            obstacleLeft.physicsBody?.categoryBitMask = obstacleCategoryBitMask
            obstacleLeft.physicsBody?.restitution = 0.0
            obstacleLeft.physicsBody?.isDynamic = false
            obstacleLeft.physicsBody?.allowsRotation = false
            obstacleLeft.physicsBody?.affectedByGravity = false
            
            obstacleRight.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: obstacleRight.size.width, height: obstacleRight.size.height))
            obstacleRight.physicsBody?.categoryBitMask = obstacleCategoryBitMask
            obstacleRight.physicsBody?.restitution = 0.0
            obstacleRight.physicsBody?.isDynamic = false
            obstacleRight.physicsBody?.allowsRotation = false
            obstacleRight.physicsBody?.affectedByGravity = false
            
            addChild(obstacleLeft)
            addChild(obstacleRight)

            let actionMoveLeft = SKAction.move(to: CGPoint(x: obstacleLeft.position.x, y: size.height + obstacleLeft.size.height), duration: 6)
            let actionMoveRight = SKAction.move(to: CGPoint(x: obstacleRight.position.x, y: size.height + obstacleRight.size.height), duration: 6)
            let actionMoveDone = SKAction.removeFromParent()
            obstacleLeft.run(SKAction.sequence([actionMoveLeft, actionMoveDone]))
            obstacleRight.run(SKAction.sequence([actionMoveRight, actionMoveDone]))
        } else {
            let obstacle = SKSpriteNode(color: UIColor(Color.brown), size: CGSize(width: size.width * 0.6, height: size.height * 0.06))
            
            obstacle.position = CGPoint(x: CGFloat(randomObstacleType.rawValue) * (size.width - obstacle.size.width) / 2, y: -(size.height - obstacle.size.height) / 2 - obstacle.size.height)
            
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: obstacle.size.width, height: obstacle.size.height))
            obstacle.physicsBody?.categoryBitMask = obstacleCategoryBitMask
            obstacle.physicsBody?.restitution = 0.0
            obstacle.physicsBody?.isDynamic = false
            obstacle.physicsBody?.allowsRotation = false
            obstacle.physicsBody?.affectedByGravity = false
            
            addChild(obstacle)

            let actionMove = SKAction.move(to: CGPoint(x: obstacle.position.x, y: size.height + obstacle.size.height), duration: 6)
            let actionMoveDone = SKAction.removeFromParent()
            obstacle.run(SKAction.sequence([actionMove, actionMoveDone]))
        }
        
        maxObstacles -= 1
        
        if maxObstacles == 0 {
            self.view?.scene?.run(SKAction.wait(forDuration: 7), completion: {
                if let nextScene = self.getNextScene() {
                    nextScene.scaleMode = .aspectFill
                    nextScene.isUserInteractionEnabled = true
                    self.view?.presentScene(nextScene)
                }
            })
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.repeat(SKAction.sequence([SKAction.run(addObstacle), SKAction.wait(forDuration: 3)]), count: maxObstacles)]), withKey: "addObstacles")
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        if contact.bodyA.node?.physicsBody?.categoryBitMask == playerCategoryBitMask && contact.bodyB.node?.physicsBody?.categoryBitMask == obstacleCategoryBitMask || contact.bodyB.node?.physicsBody?.categoryBitMask == playerCategoryBitMask && contact.bodyA.node?.physicsBody?.categoryBitMask == obstacleCategoryBitMask {
            let obstacleBody = {
                if contact.bodyA.node?.physicsBody?.categoryBitMask == obstacleCategoryBitMask {
                    return contact.bodyA
                } else {
                    return contact.bodyB
                }
            }()
            guard let obstacleNode = obstacleBody.node else {
                // view?.presentScene(self)
                return
            }
            guard let scene = obstacleNode.scene else {
                // view?.presentScene(self)
                return
            }
            let pairObstacleNode = scene.nodes(at: CGPoint(x: -obstacleNode.position.x, y: obstacleNode.position.y)).first(where: {node in
                node.physicsBody?.categoryBitMask == obstacleCategoryBitMask
            })
            let frame = obstacleNode.frame
            
            guard let addObstacles = scene.value(forKey: "actions") as? [SKAction] else {
                // view?.presentScene(self)
                return
            }
            scene.removeAllActions()
            obstacleNode.removeAllActions()
            pairObstacleNode?.removeAllActions()
            
            let repositionPlayer = SKAction.moveTo(x: 0, duration: 1)
            let repositionObstacle = SKAction.moveTo(y: -(scene.size.height - frame.size.height) / 2 - frame.size.height, duration: 1)
            maxObstacles = 5
            
            player.run(repositionPlayer)
            obstacleNode.run(repositionObstacle, completion: {
                obstacleNode.removeFromParent()
                scene.run(SKAction.sequence(addObstacles))
            })
            pairObstacleNode?.run(repositionObstacle, completion: {
                pairObstacleNode?.removeFromParent()
            })
        }
    }
}
