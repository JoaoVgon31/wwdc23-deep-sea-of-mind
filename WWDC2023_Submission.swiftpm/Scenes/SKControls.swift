import Foundation
import SpriteKit

protocol SKControls {
    static var currentReadPage: Int { get set }
    var readPreviousControl: SKSpriteNode { get nonmutating set }
    var readNextControl: SKSpriteNode { get nonmutating set }
    var upControl: SKSpriteNode { get nonmutating set }
    var downControl: SKSpriteNode { get nonmutating set }
    var rightControl: SKSpriteNode { get nonmutating set }
    var leftControl: SKSpriteNode { get nonmutating set }
    
    func initControlsNodes(on scene: SKScene, withRead: Bool)
    func handleControlsTouchBegan(touchedNodes: [SKNode], player: SKSpriteNode, readNode: SKSpriteNode, previousNode: SKSpriteNode, nextNode: SKSpriteNode, readRange: ClosedRange<Int>, canMove: Bool)
    func handleControlsTouchEnded(touchedNodes: [SKNode], player: SKSpriteNode)
}

extension SKControls {
    func initControlsNodes(on scene: SKScene, withRead: Bool) {
        if withRead {
            if let readNextControl = scene.childNode(withName: "NextControl") as? SKSpriteNode {
                self.readNextControl = readNextControl
            }
            if let readPreviousControl = scene.childNode(withName: "PreviousControl") as? SKSpriteNode {
                self.readPreviousControl = readPreviousControl
                self.readPreviousControl.isHidden = true
            }
        }
        if let upControl = scene.childNode(withName: "UpControl") as? SKSpriteNode {
            self.upControl = upControl
        }
        if let downControl = scene.childNode(withName: "DownControl") as? SKSpriteNode {
            self.downControl = downControl
        }
        if let rightControl = scene.childNode(withName: "RightControl") as? SKSpriteNode {
            self.rightControl = rightControl
        }
        if let leftControl = scene.childNode(withName: "LeftControl") as? SKSpriteNode {
            self.leftControl = leftControl
        }
    }
    
    func handleControlsTouchBegan(touchedNodes: [SKNode], player: SKSpriteNode, readNode: SKSpriteNode, previousNode: SKSpriteNode, nextNode: SKSpriteNode, readRange: ClosedRange<Int>, canMove: Bool) {
        if touchedNodes.contains(readNextControl) {
            BasicGameScene.currentReadPage += 1
            if BasicGameScene.currentReadPage == readRange.upperBound {
                nextNode.isHidden = true
            }
            if BasicGameScene.currentReadPage > readRange.lowerBound {
                previousNode.isHidden = false
            }
            if readRange.contains(BasicGameScene.currentReadPage) {
                readNode.texture = SKTexture(imageNamed: "Text-\(BasicGameScene.currentReadPage)")
            }
        }
        if touchedNodes.contains(readPreviousControl) {
            BasicGameScene.currentReadPage -= 1
            if BasicGameScene.currentReadPage == readRange.lowerBound {
                previousNode.isHidden = true
            }
            if BasicGameScene.currentReadPage < readRange.upperBound {
                nextNode.isHidden = false
            }
            if readRange.contains(BasicGameScene.currentReadPage) {
                readNode.texture = SKTexture(imageNamed: "Text-\(BasicGameScene.currentReadPage)")
            }
        }
        if canMove {
            if touchedNodes.contains(upControl) {
                if BasicGameScene.playerIsOnSubmarine {
                    player.animateSprite(framesName: "PlayerSubmarine", framesQuantity: 2, timePerFrame: 0.07)
                } else {
                    player.animateSprite(framesName: "SwimUp", framesQuantity: 4, timePerFrame: 0.24)
                }
                player.physicsBody?.velocity = CGVector(dx: 0.0, dy: 500.0)
            }
            if touchedNodes.contains(downControl) {
                if BasicGameScene.playerIsOnSubmarine {
                    player.animateSprite(framesName: "PlayerSubmarine", framesQuantity: 2, timePerFrame: 0.07)
                } else {
                    player.animateSprite(framesName: "SwimDown", framesQuantity: 4, timePerFrame: 0.24)
                }
                player.physicsBody?.velocity = CGVector(dx: 0.0, dy: -500.0)
            }
            if touchedNodes.contains(rightControl) {
                if BasicGameScene.playerIsOnSubmarine {
                    player.animateSprite(framesName: "PlayerSubmarine", framesQuantity: 2, timePerFrame: 0.07)
                } else {
                    player.animateSprite(framesName: "Swim", framesQuantity: 4, timePerFrame: 0.24)
                }
                player.physicsBody?.velocity = CGVector(dx: 600.0, dy: 0.0)
            }
            if touchedNodes.contains(leftControl) {
                if BasicGameScene.playerIsOnSubmarine {
                    player.xScale = -player.xScale
                    player.animateSprite(framesName: "PlayerSubmarine", framesQuantity: 2, timePerFrame: 0.07)
                } else {
                    player.animateSprite(framesName: "SwimLeft", framesQuantity: 4, timePerFrame: 0.24)
                }
                player.physicsBody?.velocity = CGVector(dx: -600.0, dy: 0.0)
            }
        }
    }
    
    func handleControlsTouchEnded(touchedNodes: [SKNode], player: SKSpriteNode) {
        if touchedNodes.contains(upControl) || touchedNodes.contains(downControl) || touchedNodes.contains(rightControl) || touchedNodes.contains(leftControl) {
            if !BasicGameScene.playerIsOnSubmarine {
                player.animateSprite(framesName: "PlayerDiver", framesQuantity: 1, timePerFrame: 0.24)
            } else if touchedNodes.contains(leftControl) {
                player.xScale = -player.xScale
            }
            player.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        }
    }
}

