import Foundation
import SpriteKit
 
class GameScene3: BasicGameScene {
    override func getNextScene() -> SKScene? {
        return GameScene4(fileNamed: "GameScene4.sks")
    }
    
    override func getReadRange() -> ClosedRange<Int> {
        return 7...9
    }
    
    override func initBoundaries() {
        initBoundariesNodes(on: self, boundaryCategoryBitMask: boundaryCategoryBitMask, passageCategoryBitMask: passageCategoryBitMask, passageSide: .Right)
    }
}
