import SwiftUI
import SpriteKit

struct ContentView: View {
    let scene: SKScene? = GameScene(fileNamed: "GameScene.sks")
    
    init() {
        scene?.scaleMode = .aspectFill
        scene?.isUserInteractionEnabled = true
    }
    
    var body: some View {
        if let scene = scene {
            SpriteView(scene: scene)
        }
    }
}
