import Foundation
import SpriteKit
 
class GameScene4: BasicGameScene {
    var submarine: SKSpriteNode = SKSpriteNode()
    var playerSubmarine: SKSpriteNode = SKSpriteNode()
    
    override func getNextScene() -> SKScene? {
        return GameScene5(fileNamed: "GameScene5.sks")
    }
    
    override func getReadRange() -> ClosedRange<Int> {
        return 10...10
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        if let submarine = childNode(withName: "Submarine") as? SKSpriteNode {
            self.submarine = submarine
        }
        if let playerSubmarine = childNode(withName: "PlayerSubmarine") as? SKSpriteNode {
            self.playerSubmarine = playerSubmarine
            self.playerSubmarine.isHidden = true
        }
        self.canMove = false
        self.player.run(SKAction.moveTo(x: 0, duration: 3), completion: {
            self.canMove = true
            self.submarine.removeFromParent()
            self.player.removeFromParent()
            self.playerSubmarine.isHidden = false
            self.player = self.playerSubmarine
            self.player.physicsBody?.contactTestBitMask = self.passageCategoryBitMask + self.obstacleCategoryBitMask
            BasicGameScene.playerIsOnSubmarine = true
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        handleControlsTouchBegan(touchedNodes: touchedNodes, player: player, readNode: read, previousNode: readPreviousControl, nextNode: readNextControl, readRange: getReadRange(), canMove: canMove)
    }
}
