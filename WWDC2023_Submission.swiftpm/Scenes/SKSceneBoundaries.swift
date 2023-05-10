import Foundation
import SpriteKit

protocol SKSceneBoundaries {
    var rightBoundary: SKSpriteNode { get nonmutating set }
    var topBoundary: SKSpriteNode { get nonmutating set }
    var leftBoundary: SKSpriteNode { get nonmutating set }
    var bottomBoundary: SKSpriteNode { get nonmutating set }
    
    func initBoundariesNodes(on scene: SKScene, boundaryCategoryBitMask: UInt32, passageCategoryBitMask: UInt32, passageSide: BoundarySide)
}

extension SKSceneBoundaries {
    func initBoundariesNodes(on scene: SKScene, boundaryCategoryBitMask: UInt32, passageCategoryBitMask: UInt32, passageSide: BoundarySide) {
        if let rightBoundary = scene.childNode(withName: "RightBoundary") as? SKSpriteNode {
            self.rightBoundary = rightBoundary
            self.rightBoundary.physicsBody?.restitution = 0.0
            if passageSide == .Right {
                self.rightBoundary.physicsBody?.categoryBitMask = passageCategoryBitMask
            } else {
                self.rightBoundary.physicsBody?.categoryBitMask = boundaryCategoryBitMask
            }
        }
        if let topBoundary = scene.childNode(withName: "TopBoundary") as? SKSpriteNode {
            self.topBoundary = topBoundary
            self.topBoundary.physicsBody?.restitution = 0.0
            if passageSide == .Top {
                self.topBoundary.physicsBody?.categoryBitMask = passageCategoryBitMask
            } else {
                self.topBoundary.physicsBody?.categoryBitMask = boundaryCategoryBitMask
            }
        }
        if let leftBoundary = scene.childNode(withName: "LeftBoundary") as? SKSpriteNode {
            self.leftBoundary = leftBoundary
            self.leftBoundary.physicsBody?.restitution = 0.0
            if passageSide == .Left {
                self.leftBoundary.physicsBody?.categoryBitMask = passageCategoryBitMask
            } else {
                self.leftBoundary.physicsBody?.categoryBitMask = boundaryCategoryBitMask
            }
        }
        if let bottomBoundary = scene.childNode(withName: "BottomBoundary") as? SKSpriteNode {
            self.bottomBoundary = bottomBoundary
            self.bottomBoundary.physicsBody?.restitution = 0.0
            if passageSide == .Bottom {
                self.bottomBoundary.physicsBody?.categoryBitMask = passageCategoryBitMask
            } else {
                self.bottomBoundary.physicsBody?.categoryBitMask = boundaryCategoryBitMask
            }
        }
    }
}
