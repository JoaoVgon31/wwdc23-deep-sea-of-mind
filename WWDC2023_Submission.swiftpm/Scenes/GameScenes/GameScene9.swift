import Foundation
import SpriteKit
 
class GameScene9: BasicGameScene {
    override func getReadRange() -> ClosedRange<Int> {
        return 16...23
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        BasicGameScene.playerIsOnSubmarine = false
    }
}
