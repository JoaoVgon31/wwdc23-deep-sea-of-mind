import Foundation
import SpriteKit
 
class GameScene6: BasicGameScene {
    override func getNextScene() -> SKScene? {
        return GameScene7(fileNamed: "GameScene7.sks")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.canMove = true
    }
}
