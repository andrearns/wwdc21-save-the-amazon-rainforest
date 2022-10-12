import SpriteKit
import UIKit

public class JungleFire1: SKScene, SKPhysicsContactDelegate {
    // Camera
    var cam = SKCameraNode()
    
    // Big Fire
    var bigFire1: SKSpriteNode!
    var bigFire2: SKSpriteNode!
    var bigFireAnimation: SKAction!
    
    // Smoke
    var smoke: SKSpriteNode!
    var smokeAnimation = SKAction.group([SKAction.scaleY(to: 3, duration: 10), SKAction.moveTo(y: 800, duration: 10)])
    var smokeDelay = SKAction.wait(forDuration: 3)
    
    // Animations
    var fireDelay = SKAction.wait(forDuration: 0.3)
    var xGrowAnimation = SKAction.scaleX(to: 1.933, duration: 5)
    var yGrowAnimation = SKAction.scaleY(to: 2.772, duration: 5)
    var tapToContinueDelay = SKAction.wait(forDuration: 7)
    var fadeInTapToContinue = SKAction.fadeAlpha(to: 1, duration: 1)
    
    // Tap to continue button
    var tapToContinueButton: SKLabelNode!
    
    // Sounds
    let growingFireSound = SKAction.playSoundFileNamed("growing-fire", waitForCompletion: true)
    
    override public func didMove(to view: SKView) {
        // Add camera
        self.camera = cam
        cam.setScale(1)
        addChild(cam)
        
        // Big fire
        bigFire1 = self.childNode(withName: "BigFire1") as? SKSpriteNode
        bigFire1.setScale(0.01)
        bigFire2 = self.childNode(withName: "BigFire2") as? SKSpriteNode
        bigFire2.setScale(0.01)
        setupBigFireAnimation()
        bigFire1.run(SKAction.group([bigFireAnimation, xGrowAnimation, yGrowAnimation]))
        bigFire2.run(SKAction.group([fireDelay, bigFireAnimation, xGrowAnimation, yGrowAnimation]))
        
        // Smoke
        smoke = self.childNode(withName: "Smoke") as? SKSpriteNode
        smoke.run(SKAction.sequence([smokeDelay, smokeAnimation]))
        
        // Tap to continue button
        tapToContinueButton = self.childNode(withName: "TapToContinue") as? SKLabelNode
        tapToContinueButton.alpha = 0
        tapToContinueButton.run(SKAction.sequence([tapToContinueDelay, fadeInTapToContinue]))
        
        // Sounds
        run(growingFireSound)
    }
    
    func setupBigFireAnimation() {
        // Fire animation on the third stage
        
        var bigFireList = [SKTexture]()
        
        for i in 1...7 {
           bigFireList.append(SKTexture(imageNamed: "fire\(i)"))
        }
        
        bigFireAnimation = SKAction.repeatForever(SKAction.animate(with: bigFireList, timePerFrame: 0.11))
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let scene = GameScene3(fileNamed: "GameScene3") {
             scene.scaleMode = .aspectFit
             self.view!.presentScene(scene)
        }
        print("Go to phase 3")
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override public func update(_ currentTime: TimeInterval) {
        
    }
}

