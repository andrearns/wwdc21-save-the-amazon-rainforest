import AVFoundation
import SpriteKit
import UIKit

public class JungleFire2: SKScene, SKPhysicsContactDelegate {
    // Camera
    var cam = SKCameraNode()
    
    // Big Fire
    var bigFire1: SKSpriteNode!
    var bigFire2: SKSpriteNode!
    var bigFire3: SKSpriteNode!
    var bigFire4: SKSpriteNode!
    var bigFireAnimation: SKAction!
    
    // Clouds
    var leftCloud: SKSpriteNode!
    var rightCloud: SKSpriteNode!
    
    // After rain background
    var afterRainBackground: SKSpriteNode!
    
    // Rain
    var rainDrops: SKEmitterNode!
    
    // Final overlay
    var overlay: SKSpriteNode!
    var reflectionText: SKSpriteNode!
    var logo: SKSpriteNode!
    var madeWithLove: SKSpriteNode!
    
    // Animations
    var fireDelay = SKAction.wait(forDuration: 0.3)
    var xShrinkAnimation = SKAction.scaleX(to: 0, duration: 5)
    var yShrinkAnimation = SKAction.scaleY(to: 0, duration: 5)
    var fadeOutRain = SKAction.fadeAlpha(to: 0, duration: 1)
    var tapToRainDelay = SKAction.wait(forDuration: 3)
    var tapToRainFadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
    var backgroundDelay = SKAction.wait(forDuration: 3)
    var fadeInBackground = SKAction.fadeAlpha(to: 1, duration: 3)
    var overlayDelay = SKAction.wait(forDuration: 8)
    var fadeInOverlay = SKAction.fadeAlpha(to: 0.7, duration: 1)
    
    // Sounds
    var audioPlayer: AVAudioPlayer?
    let thunderSound = SKAction.playSoundFileNamed("thunder", waitForCompletion: true)
    
    // Tap to continue button
    var tapToRain: SKLabelNode!
    
    override public func didMove(to view: SKView) {
        // Add camera
        self.camera = cam
        cam.setScale(1)
        addChild(cam)
        
        // Clouds
        leftCloud = self.childNode(withName: "LeftCloud") as? SKSpriteNode
        rightCloud = self.childNode(withName: "RightCloud") as? SKSpriteNode
        
        leftCloud.run(SKAction.moveTo(x: -200, duration: 3))
        rightCloud.run(SKAction.moveTo(x: 320, duration: 3))
        
        // Big fire
        bigFire1 = self.childNode(withName: "BigFire1") as? SKSpriteNode
        bigFire1.xScale = 1.933
        bigFire1.yScale = 2.772
        
        bigFire2 = self.childNode(withName: "BigFire2") as? SKSpriteNode
        bigFire2.xScale = 1.933
        bigFire2.yScale = 2.772
        
        bigFire3 = self.childNode(withName: "BigFire3") as? SKSpriteNode
        bigFire3.xScale = 1.933
        bigFire3.yScale = 2.772
        
        bigFire4 = self.childNode(withName: "BigFire4") as? SKSpriteNode
        bigFire4.xScale = 1.933
        bigFire4.yScale = 2.772
        
        setupBigFireAnimation()
        bigFire1.run(bigFireAnimation)
        bigFire2.run(bigFireAnimation)
        bigFire3.run(bigFireAnimation)
        bigFire4.run(bigFireAnimation)
        
        // Rain
        rainDrops = self.childNode(withName: "Rain") as? SKEmitterNode
        rainDrops.alpha = 0
        rainDrops.particleBirthRate = 0
        
        // After rain background
        afterRainBackground = self.childNode(withName: "AfterRainBackground") as? SKSpriteNode
        
        // Tap to rain button
        tapToRain = self.childNode(withName: "TapToRain") as? SKLabelNode
        tapToRain.alpha = 0
        tapToRain.run(SKAction.sequence([tapToRainDelay, tapToRainFadeIn]))
        
        // Overlay
        overlay = SKSpriteNode(color: UIColor.black, size: self.size)
        overlay.alpha = 0
        overlay.zPosition = 1000
        cam.addChild(overlay)
        
        // Reflection text
        reflectionText = self.childNode(withName: "ReflectionText") as? SKSpriteNode
        reflectionText.zPosition = 1001
        
        // Logo overlay
        logo = self.childNode(withName: "Logo") as? SKSpriteNode
        logo.zPosition = 1001
        
        // Made with love text
        madeWithLove = self.childNode(withName: "MadeWithLove") as? SKSpriteNode
        madeWithLove.zPosition = 1001
        
        // Forest sound
        playSound(sound: "floresta-fogo-ambiencia", type: "wav", volume: 0.5)
    }
    
    func playSound(sound: String, type: String, volume: Float, loops: Int = -1) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.volume = volume
                audioPlayer?.numberOfLoops = loops
                audioPlayer?.play()
            } catch {
                print("ERROR")
            }
        }
    }

    func runOverlay() {
        overlay.run(SKAction.sequence([overlayDelay, fadeInOverlay]))
        logo.run(SKAction.sequence([overlayDelay, fadeInOverlay]))
        reflectionText.run(SKAction.sequence([overlayDelay, fadeInOverlay]))
        madeWithLove.run(SKAction.sequence([overlayDelay, fadeInOverlay]))
    }
    
    func rain() {
        run(thunderSound)
        playSound(sound: "rain", type: "wav", volume: 0.5)
        rainDrops.particleBirthRate = 2
        rainDrops.alpha = 1
        bigFire1.run(SKAction.group([xShrinkAnimation, yShrinkAnimation]))
        bigFire2.run(SKAction.group([fireDelay, xShrinkAnimation, yShrinkAnimation]))
        bigFire3.run(SKAction.group([xShrinkAnimation, yShrinkAnimation]))
        bigFire4.run(SKAction.group([bigFireAnimation, xShrinkAnimation, yShrinkAnimation]))
        
        tapToRain.run(fadeOutRain)
        changeBackground()
        runOverlay()
        
    }
    
    func setupBigFireAnimation() {
        // Fire animation on the third stage
        
        var bigFireList = [SKTexture]()
        
        for i in 1...7 {
           bigFireList.append(SKTexture(imageNamed: "fire\(i)"))
        }
        
        bigFireAnimation = SKAction.repeatForever(SKAction.animate(with: bigFireList, timePerFrame: 0.11))
    }
    
    func changeBackground() {
        afterRainBackground.run(SKAction.sequence([backgroundDelay, fadeInBackground]))
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
        rain()
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


