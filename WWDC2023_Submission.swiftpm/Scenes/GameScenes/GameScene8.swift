import Foundation
import SpriteKit
 
class GameScene8: ObstaclesGameScene {
    var monster: SKSpriteNode = SKSpriteNode()
    
    override func getNextScene() -> SKScene? {
        return GameScene9(fileNamed: "GameScene9.sks")
    }
    
    override func getReadRange() -> ClosedRange<Int> {
        return 14...15
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.canMove = true
        view.scene?.isPaused = true
        if let monster = childNode(withName: "Monster") as? SKSpriteNode {
            self.monster = monster
            self.monster.physicsBody?.restitution = 0.0
            self.monster.physicsBody?.categoryBitMask = monsterCategoryBitMask
            self.monster.physicsBody?.contactTestBitMask = obstacleCategoryBitMask
            self.monster.run(SKAction.moveBy(x: 0, y: -350, duration: 2))
            self.monster.animateSprite(framesName: "Monster", framesQuantity: 2, timePerFrame: 1)
        }
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        if contact.bodyA.node?.physicsBody?.categoryBitMask == monsterCategoryBitMask && contact.bodyB.node?.physicsBody?.categoryBitMask == obstacleCategoryBitMask {
            guard let obstacleNode = contact.bodyB.node else {
                // view?.presentScene(self)
                return
            }
            guard let scene = obstacleNode.scene else {
                // view?.presentScene(self)
                return
            }
            let frame = obstacleNode.frame
            
            obstacleNode.removeAllActions()
            let fallObstacle = SKAction.moveTo(y: -(scene.size.height - frame.size.height) / 2 - frame.size.height, duration: 4)
            obstacleNode.run(fallObstacle)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        handleControlsTouchBegan(touchedNodes: touchedNodes, player: player, readNode: read, previousNode: readPreviousControl, nextNode: readNextControl, readRange: getReadRange(), canMove: canMove)
        
        if BasicGameScene.currentReadPage == getReadRange().upperBound {
            self.view?.scene?.isPaused = false
            view?.scene?.run(SKAction.wait(forDuration: 3), completion: {
                self.read.isHidden = true
                self.readNextControl.isHidden = true
                self.readPreviousControl.isHidden = true
            })
        }
    }
}
