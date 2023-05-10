import Foundation
import SpriteKit

extension SKSpriteNode {
    func animateSprite(framesName: String, framesQuantity: Int, timePerFrame: TimeInterval) {
        var frames: [SKTexture] = []
        for i in 1...framesQuantity {
            let frame = SKTexture(imageNamed: "\(framesName)-\(i)")
            frames.append(frame)
        }
        self.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: timePerFrame)))
    }
}
