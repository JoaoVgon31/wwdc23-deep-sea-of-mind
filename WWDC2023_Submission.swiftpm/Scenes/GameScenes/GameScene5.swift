import Foundation
import SpriteKit
 
class GameScene5: BasicGameScene {
    override func getNextScene() -> SKScene? {
        return GameScene6(fileNamed: "GameScene6.sks")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.canMove = true
    }
}
