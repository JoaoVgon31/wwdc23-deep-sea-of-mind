import Foundation
import SwiftUI
import SpriteKit
 
class GameScene7: ObstaclesGameScene {
    override func getNextScene() -> SKScene? {
        return GameScene8(fileNamed: "GameScene8.sks")
    }
    
    override func getReadRange() -> ClosedRange<Int> {
        return 11...13
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        view.scene?.isPaused = true
        self.player.run(SKAction.moveTo(y: 20, duration: 2))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        handleControlsTouchBegan(touchedNodes: touchedNodes, player: player, readNode: read, previousNode: readPreviousControl, nextNode: readNextControl, readRange: getReadRange(), canMove: canMove)
        
        if BasicGameScene.currentReadPage == getReadRange().upperBound {
            self.canMove = true
            self.view?.scene?.isPaused = false
            view?.scene?.run(SKAction.wait(forDuration: 2), completion: {
                self.read.isHidden = true
                self.readNextControl.isHidden = true
                self.readPreviousControl.isHidden = true
            })
        }
    }
}

