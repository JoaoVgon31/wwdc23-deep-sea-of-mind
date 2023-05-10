import Foundation
import SpriteKit
 
class GameScene2: BasicGameScene {
    override func getNextScene() -> SKScene? {
        return GameScene3(fileNamed: "GameScene3.sks")
    }
    
    override func getReadRange() -> ClosedRange<Int> {
        return 4...6
    }
    
    override func initBoundaries() {
        initBoundariesNodes(on: self, boundaryCategoryBitMask: boundaryCategoryBitMask, passageCategoryBitMask: passageCategoryBitMask, passageSide: .Right)
    }
}
