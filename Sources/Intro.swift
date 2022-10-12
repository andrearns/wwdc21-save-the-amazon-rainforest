import AVFoundation
import SpriteKit
import UIKit

enum IntroState {
    case first
    case second
    case third
    case fourth
}

public class Intro: SKScene, SKPhysicsContactDelegate {
    // Intro
    var introStatus: IntroState = .first
    
    // Camera
    var cam = SKCameraNode()
    
    // Background
    var background: SKSpriteNode!
    var backgroundAnimation: SKAction!
    
    // Number labels
    var numberOne: SKSpriteNode!
    var numberTwo: SKSpriteNode!
    var numberThree: SKSpriteNode!
    var numberFour: SKSpriteNode!
    
    // Texts
    var introTextOne: SKSpriteNode!
    var introTextTwo: SKSpriteNode!
    var introTextThree: SKSpriteNode!
    var introTextFour: SKSpriteNode!
    var tapToContinue: SKLabelNode!
    
    // Animations
    var fadeInText = SKAction.fadeAlpha(to: 1, duration: 0.3)
    var fadeOutText = SKAction.fadeAlpha(to: 0, duration: 0.3)
    var fadeOutTapToContinue = SKAction.fadeAlpha(to: 0, duration: 2)
    var fadeInTapToContinue = SKAction.fadeAlpha(to: 1, duration: 2)
    
    // Sounds
    var audioPlayer: AVAudioPlayer?
    
    override public func didMove(to view: SKView) {
        // Add camera
        self.camera = cam
        cam.setScale(1)
        addChild(cam)
        
        // Background
        background = self.childNode(withName: "IntroBackground") as? SKSpriteNode
        setupMoveBackground()
        background.run(backgroundAnimation)
        
        // Tap to continue label
        tapToContinue = self.childNode(withName: "TapToContinue") as? SKLabelNode
        tapToContinue.run(SKAction.repeatForever(SKAction.sequence([fadeOutTapToContinue, fadeInTapToContinue])))
        
        // Numbers
        numberOne = SKSpriteNode(imageNamed: "1")
        numberOne.alpha = 1
        numberOne.setScale(0.6)
        numberOne.position = CGPoint(x: -90, y: -220)
        
        numberTwo = SKSpriteNode(imageNamed: "2")
        numberTwo.alpha = 1
        numberTwo.setScale(0.6)
        numberTwo.position = CGPoint(x: -30, y: -220)
        
        numberThree = SKSpriteNode(imageNamed: "3")
        numberThree.alpha = 1
        numberThree.setScale(0.6)
        numberThree.position = CGPoint(x: 30, y: -220)
        
        numberFour = SKSpriteNode(imageNamed: "4")
        numberFour.alpha = 1
        numberFour.setScale(0.6)
        numberFour.position = CGPoint(x: 90, y: -220)
        
        cam.addChild(numberOne)
        cam.addChild(numberTwo)
        cam.addChild(numberThree)
        cam.addChild(numberFour)
        
        // Texts
        introTextOne = SKSpriteNode(imageNamed: "intro1")
        introTextOne.alpha = 1
        introTextOne.setScale(1.2)
        introTextOne.position = CGPoint(x: 0, y: 0)
        
        introTextTwo = SKSpriteNode(imageNamed: "intro2")
        introTextTwo.alpha = 0
        introTextTwo.setScale(1.2)
        introTextTwo.position = CGPoint(x: 0, y: 0)
        
        introTextThree = SKSpriteNode(imageNamed: "intro3")
        introTextThree.alpha = 0
        introTextThree.setScale(1.2)
        introTextThree.position = CGPoint(x: 0, y: 0)
        
        introTextFour = SKSpriteNode(imageNamed: "intro4")
        introTextFour.alpha = 0
        introTextFour.setScale(1.2)
        introTextFour.position = CGPoint(x: 0, y: 0)
        
        cam.addChild(introTextOne)
        cam.addChild(introTextTwo)
        cam.addChild(introTextThree)
        cam.addChild(introTextFour)
        
        // Forest sound
        playSound(sound: "floresta-ambiencia", type: "wav", volume: 0.5)
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
    
    func setupMoveBackground() {
        backgroundAnimation = SKAction.moveTo(x: -200, duration: 30)
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
        if introStatus == .first {
            introStatus = .second
            introTextOne.run(fadeOutText)
            introTextTwo.run(fadeInText)
        } else if introStatus == .second {
            introStatus = .third
            introTextTwo.run(fadeOutText)
            introTextThree.run(fadeInText)
        } else if introStatus == .third {
            introStatus = .fourth
            introTextThree.run(fadeOutText)
            introTextFour.run(fadeInText)
        } else {
            if let scene = GameScene1(fileNamed: "GameScene1") {
                 scene.scaleMode = .aspectFit
                 self.view!.presentScene(scene)
            }
            print("Go to phase 1")
            audioPlayer?.stop()
        }
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
        if introStatus == .first {
            numberOne.setScale(0.9)
        } else if introStatus == .second {
            numberOne.setScale(0.6)
            numberTwo.setScale(0.9)
        } else if introStatus == .third {
            numberTwo.setScale(0.6)
            numberThree.setScale(0.9)
        } else {
            numberOne.setScale(0.6)
            numberTwo.setScale(0.6)
            numberThree.setScale(0.6)
            numberFour.setScale(0.9)
        }
    }
}

