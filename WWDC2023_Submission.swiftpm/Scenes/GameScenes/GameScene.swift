import Foundation
import SpriteKit
 
class GameScene: BasicGameScene {
    override func getNextScene() -> SKScene? {
        return GameScene2(fileNamed: "GameScene2.sks")
    }
    
    override func initBoundaries() {
        initBoundariesNodes(on: self, boundaryCategoryBitMask: boundaryCategoryBitMask, passageCategoryBitMask: passageCategoryBitMask, passageSide: .Right)
    }
}
