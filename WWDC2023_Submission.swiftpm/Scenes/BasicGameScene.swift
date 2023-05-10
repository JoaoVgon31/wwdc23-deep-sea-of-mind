import Foundation
import SpriteKit

enum BoundarySide {
    case Right
    case Top
    case Left
    case Bottom
}
 
class BasicGameScene: SKScene, SKPhysicsContactDelegate, SKSceneBoundaries, SKControls {
    static var currentReadPage = 1
    static var playerIsOnSubmarine = false
    var canMove = false
    
    let playerCategoryBitMask: UInt32 = 0x1 << 1
    let passageCategoryBitMask: UInt32 = 0x1 << 2
    let boundaryCategoryBitMask: UInt32 = 0x1 << 3
    let obstacleCategoryBitMask: UInt32 = 0x1 << 4
    let monsterCategoryBitMask: UInt32 = 0x1 << 5
    let submarineCategoryBitMask: UInt32 = 0x1 << 6
    
    var rightBoundary: SKSpriteNode = SKSpriteNode()
    var topBoundary: SKSpriteNode = SKSpriteNode()
    var leftBoundary: SKSpriteNode = SKSpriteNode()
    var bottomBoundary: SKSpriteNode = SKSpriteNode()
    var readNextControl: SKSpriteNode = SKSpriteNode()
    var readPreviousControl: SKSpriteNode = SKSpriteNode()
    var upControl: SKSpriteNode = SKSpriteNode()
    var downControl: SKSpriteNode = SKSpriteNode()
    var rightControl: SKSpriteNode = SKSpriteNode()
    var leftControl: SKSpriteNode = SKSpriteNode()
    var player: SKSpriteNode = SKSpriteNode()
    var read: SKSpriteNode = SKSpriteNode()
    
    func getNextScene() -> SKScene? {
        return nil
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.physicsBody?.categoryBitMask == passageCategoryBitMask || contact.bodyA.node?.physicsBody?.categoryBitMask == passageCategoryBitMask {
            if let nextScene = getNextScene() {
                nextScene.scaleMode = .aspectFill
                nextScene.isUserInteractionEnabled = true
                self.view?.presentScene(nextScene)
            }
        }
    }
    
    func initBoundaries() {
        initBoundariesNodes(on: self, boundaryCategoryBitMask: boundaryCategoryBitMask, passageCategoryBitMask: passageCategoryBitMask, passageSide: .Bottom)
    }
    
    func initControls() {
        initControlsNodes(on: self, withRead: true)
    }
    
    func getReadRange() -> ClosedRange<Int> {
        return 1...3
    }
    
    override func didMove(to view: SKView) {
        BasicGameScene.currentReadPage = getReadRange().lowerBound
        physicsWorld.contactDelegate = self
        
        initBoundaries()
        initControls()
        if getReadRange().upperBound == getReadRange().lowerBound {
            self.readNextControl.isHidden = true
        }
        
        if let player = childNode(withName: "Player") as? SKSpriteNode {
            self.player = player
            self.player.physicsBody?.restitution = 0.0
            self.player.physicsBody?.categoryBitMask = playerCategoryBitMask
            self.player.physicsBody?.collisionBitMask = boundaryCategoryBitMask
            self.player.physicsBody?.contactTestBitMask = passageCategoryBitMask + obstacleCategoryBitMask
            if !BasicGameScene.playerIsOnSubmarine {
                self.player.animateSprite(framesName: "PlayerDiver", framesQuantity: 5, timePerFrame: 0.24)
            }
        }
        if let read = childNode(withName: "Read") as? SKSpriteNode {
            self.read = read
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if BasicGameScene.currentReadPage == getReadRange().upperBound {
            canMove = true
        }
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        handleControlsTouchBegan(touchedNodes: touchedNodes, player: player, readNode: read, previousNode: readPreviousControl, nextNode: readNextControl, readRange: getReadRange(), canMove: canMove)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        handleControlsTouchEnded(touchedNodes: touchedNodes, player: player)
    }
}

