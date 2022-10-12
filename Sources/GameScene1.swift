import AVFoundation
import SpriteKit
import UIKit

public class GameScene1: SKScene, SKPhysicsContactDelegate {
    // Game
    var gameStatus: GameState = .running
    
    // Player
    var player: SKSpriteNode!
    var playerStatus: PlayerState = .standing
    var playerDirection : PlayerDirection = .right
    var xPlayerSpeed: CGFloat = 0
    var yPlayerSpeed: CGFloat = 0
    var walkAnimation: SKAction!
    var walkStatus: WalkingState = .off
    var jumpStatus: JumpingState = .off
    
    // Life
    var life: Int = 5
    var lifePoint1: SKSpriteNode!
    var lifePoint2: SKSpriteNode!
    var lifePoint3: SKSpriteNode!
    var lifePoint4: SKSpriteNode!
    var lifePoint5: SKSpriteNode!
    
    // Initial instructions
    var instructionsOverlay: SKSpriteNode!
    var instructionsStatus: InstructionsState = .on
    var tapToStart: SKLabelNode!
    var instructionsText: SKSpriteNode!
    
   // Animals
    var macacoPrego: SKSpriteNode!
    
    // Pop ups
    var macacoPregoPopUp: SKSpriteNode!
    var nextButtonMacacoPrego: SKSpriteNode!
    var overlay: SKSpriteNode!
    var popUpAnimation: SKAction!
    
    // Key
    var key: SKSpriteNode!
    var keyStatus: KeyState = .lost
    var keyGlow: SKSpriteNode!
    var keyGlowAnimation: SKAction!
    
    // Camera
    var cam = SKCameraNode()
    
    // Control buttons
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var jumpButton: SKSpriteNode!
    
    // Release button
    var releaseButton: SKSpriteNode!
    
    // Background
    var background: SKSpriteNode!
    
    // Sounds
    var audioPlayer: AVAudioPlayer?
    let lockSound = SKAction.playSoundFileNamed("lock-sound", waitForCompletion: true)
    
    // Used in delta time
    var lastUpdate = TimeInterval()
    
    override public func didMove(to view: SKView) {
        
        // Add camera on the scene
        self.camera = cam
        addChild(cam)
        cam.setScale(1.2)
        
//        view.showsPhysics = true
        
        // Add player on the scene
        player = self.childNode(withName: "Player") as? SKSpriteNode
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 230))
        body.affectedByGravity = true
        body.restitution = 0
        body.categoryBitMask = 2
        body.collisionBitMask = 1
        body.contactTestBitMask = 15
        body.allowsRotation = false
        
        player.physicsBody = body
        
        // setupJumpingAnimation()
        setupWalkingAnimation()
        
        // Add key on the scene
        key = self.childNode(withName: "Key") as? SKSpriteNode
        keyGlow = self.childNode(withName: "KeyGlow") as? SKSpriteNode
        setupKeyGlowAnimation()
        keyGlow.run(keyGlowAnimation)
       
        // Add release button of the animals on the scene
        releaseButton = self.childNode(withName: "ReleaseButton") as? SKSpriteNode
    
        // Add life points and placeholders on the screen
        setupLifePoints()
        
        // Add the left and right button on the cam
        leftButton = SKSpriteNode(imageNamed: "leftButton")
        rightButton = SKSpriteNode(imageNamed: "rightButton")
        jumpButton = SKSpriteNode(imageNamed: "jumpbutton")
        
        leftButton.alpha = 0.5
        leftButton.setScale(0.4)
        leftButton.position = CGPoint(x: -340, y: -245)

        rightButton.alpha = 0.5
        rightButton.setScale(0.4)
        rightButton.position = CGPoint(x: -220, y: -245)
        
        jumpButton.alpha = 0.5
        jumpButton.setScale(0.4)
        jumpButton.position = CGPoint(x: 340, y: -245)
        
        cam.addChild(leftButton)
        cam.addChild(rightButton)
        cam.addChild(jumpButton)
        
        // Add animal on the scene
        macacoPrego = self.childNode(withName: "MacacoPrego") as? SKSpriteNode
        macacoPrego.texture = SKTexture(imageNamed: "macacoprego-jaula")
        
        // Add pop up on the scene
        macacoPregoPopUp = SKSpriteNode(imageNamed: "macacoprego-popup")
        macacoPregoPopUp.setScale(0.75)
        macacoPregoPopUp.alpha = 0
        macacoPregoPopUp.zPosition = 1000
        macacoPregoPopUp.position = CGPoint(x: -45, y: 50)
        
        nextButtonMacacoPrego = SKSpriteNode(imageNamed: "macacoprego-nextbutton")
        nextButtonMacacoPrego.setScale(1)
        nextButtonMacacoPrego.alpha = 0
        nextButtonMacacoPrego.zPosition = 1000
        nextButtonMacacoPrego.position = CGPoint(x: -45, y: -200)
        
        overlay = SKSpriteNode(color: UIColor.black, size: self.size)
        overlay.alpha = 0
        
        cam.addChild(overlay)
        cam.addChild(macacoPregoPopUp)
        cam.addChild(nextButtonMacacoPrego)
        
        // Instructions
        instructionsOverlay = SKSpriteNode(color: UIColor.black, size: self.size)
        instructionsOverlay.alpha = 0.7
        instructionsOverlay.zPosition = 999
        cam.addChild(instructionsOverlay)
        
        instructionsText = self.childNode(withName: "InstructionsText") as? SKSpriteNode
        instructionsText.zPosition = 1001
        
        tapToStart = self.childNode(withName: "TapToStart") as? SKLabelNode
        tapToStart.zPosition = 1001
        
        // Forest sound
        playSound(sound: "floresta-ambiencia", type: "wav", volume: 0.5)
        
        self.physicsWorld.contactDelegate = self
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
    
    func setupLifePoints() {
        lifePoint1 = SKSpriteNode(imageNamed: "life-point")
        lifePoint2 = SKSpriteNode(imageNamed: "life-point")
        lifePoint3 = SKSpriteNode(imageNamed: "life-point")
        lifePoint4 = SKSpriteNode(imageNamed: "life-point")
        lifePoint5 = SKSpriteNode(imageNamed: "life-point")
        
        lifePoint1.alpha = 1
        lifePoint1.zPosition = 10
        lifePoint1.setScale(0.8)
        lifePoint1.position = CGPoint(x: -365, y: 280)
        
        lifePoint2.alpha = 1
        lifePoint2.zPosition = 10
        lifePoint2.setScale(0.8)
        lifePoint2.position = CGPoint(x: -305, y: 280)
        
        lifePoint3.alpha = 1
        lifePoint3.zPosition = 10
        lifePoint3.setScale(0.8)
        lifePoint3.position = CGPoint(x: -245, y: 280)
        
        lifePoint4.alpha = 1
        lifePoint4.zPosition = 10
        lifePoint4.setScale(0.8)
        lifePoint4.position = CGPoint(x: -185, y: 280)
        
        lifePoint5.alpha = 1
        lifePoint5.zPosition = 10
        lifePoint5.setScale(0.8)
        lifePoint5.position = CGPoint(x: -125, y: 280)
        
        cam.addChild(lifePoint1)
        cam.addChild(lifePoint2)
        cam.addChild(lifePoint3)
        cam.addChild(lifePoint4)
        cam.addChild(lifePoint5)
    }
    
    func checkLifeStatus() {
        if life == 4 {
            lifePoint5.alpha = 0.2
        } else if life == 3 {
            lifePoint4.alpha = 0.2
        } else if life == 2 {
            lifePoint3.alpha = 0.2
        } else if life == 1 {
            lifePoint2.alpha = 0.2
        } else {
            lifePoint1.alpha = 0.2
        }
    }
    
    func findKey() {
        run(lockSound)
        keyGlow.removeFromParent()

        key.removeFromParent()
        key.alpha = 0
        key.setScale(0.3)
        key.position = CGPoint(x: 340, y: 270)
        key.run(SKAction.fadeAlpha(to: 1, duration: 0.3))
        cam.addChild(key)
        
        releaseButton.texture = SKTexture(imageNamed: "releasebutton")
        releaseButton.xScale = 2
        
        keyStatus = .found
        
        print("Player got the key")
    }
    
    func releaseAnimal() {
        // Change the animal image, now without the cage
        run(lockSound)
        
        macacoPrego.texture = SKTexture(imageNamed: "macacoprego-livre")
        macacoPrego.xScale = 0.404
        macacoPrego.yScale = 0.404
        macacoPrego.zPosition = 999
        macacoPrego.position.y = macacoPrego.position.y - 32
        cam.position = CGPoint(x: 0, y: 100)
        
        key.run(SKAction.fadeAlpha(to: 0, duration: 1))
        
        popUp()
        gameStatus = .finish
        
    }
    
    func popUp() {
        // Show the pop up on the scene and stop all actions
        player.removeAllActions()
        xPlayerSpeed = 0
        
        lifePoint1.alpha = 0
        lifePoint2.alpha = 0
        lifePoint3.alpha = 0
        lifePoint4.alpha = 0
        lifePoint5.alpha = 0
        
        let delay = SKAction.wait(forDuration: 1)
        let fadeInPopUp = SKAction.fadeAlpha(to: 1, duration: 1)
        let fadeInOverlay = SKAction.fadeAlpha(to: 0.5, duration: 1)
        
        macacoPregoPopUp.run(SKAction.sequence([delay, fadeInPopUp]))
        overlay.run(SKAction.sequence([delay, fadeInOverlay]))
        nextButtonMacacoPrego.run(SKAction.sequence([delay, fadeInPopUp]))
    }
    
    func setupKeyGlowAnimation() {
        // Glow animation on the key
        
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.7)
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.7)
        
        keyGlowAnimation = SKAction.repeatForever(SKAction.sequence([fadeIn, fadeOut]))
    }
    
    func setupWalkingAnimation() {
        // Player animation when walking
        
        var walkingList = [SKTexture]()
        
        for i in 1...8 {
            walkingList.append(SKTexture(imageNamed: "walk\(i)"))
        }
        
        walkAnimation = SKAction.repeatForever(SKAction.animate(with: walkingList, timePerFrame: 0.12))
    }
    
    func walk() {
        if playerStatus == .jumping {
            return
        }
        else if jumpStatus == .off {
            player.removeAllActions()
            player.run(walkAnimation)
        }
    }
    
    func jump() {
        let jumpTexture = SKTexture(imageNamed: "curupira-jump")
        
        if playerStatus == .jumping || jumpStatus == .on {
            return
        }
        
        if playerDirection == .right {
            player.physicsBody?.velocity.dx = 100
        } else if playerDirection == .left {
            player.physicsBody?.velocity.dx = -100
        }
        
        playerStatus = .jumping

        player.physicsBody?.velocity.dy = 700

        player.texture = jumpTexture
    }
    
    func makePlayerDirection() {
        if playerDirection == .left {
            player.xScale = -0.7
        } else {
            player.xScale = 0.7
        }
    }
    
    func fadeOutInstructions() {
        instructionsOverlay.run(SKAction.fadeAlpha(to: 0, duration: 0.4))
        instructionsText.run(SKAction.fadeAlpha(to: 0, duration: 0.4))
        tapToStart.run(SKAction.fadeAlpha(to: 0, duration: 0.4))
        instructionsStatus = .off
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        // Function to report when an object touches another
        if contact.bodyA.node?.name == "Key" || contact.bodyB.node?.name == "Key" {
            findKey()
        }
        else if contact.bodyA.node?.name == "Ground" || contact.bodyB.node?.name == "Ground" {
            print("Player touched the ground")
            jumpStatus = .off
            if playerStatus == .jumping && walkStatus == .off {
                player.removeAllActions()
                playerStatus = .standing
            } else if walkStatus == .on {
                player.run(walkAnimation)
            }
        }
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if instructionsStatus == .on {
            print("Apaga as instruções")
            fadeOutInstructions()
            instructionsStatus = .off
        }
        // Left move when touches the left button
        if gameStatus == .running && leftButton.contains(convert(pos, to: cam)) && instructionsStatus == .off {
            playerDirection = .left
            xPlayerSpeed = -300
            player.xScale = -0.7
            walk()
            playerStatus = .walking
            walkStatus = .on
            
            let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.1)
            leftButton.run(fadeIn)
            
        }
        
        // Right move when touches the left button
        else if gameStatus == .running && rightButton.contains(convert(pos, to: cam)) && instructionsStatus == .off {
            playerDirection = .right
            xPlayerSpeed = 300
            player.xScale = 0.7
            walk()
            playerStatus = .walking
            walkStatus = .on
            
            let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.1)
            rightButton.run(fadeIn)
        }
        
        // Release the animal when the release button is touched
        else if releaseButton.contains(pos) && keyStatus == .found && instructionsStatus == .off {
            releaseButton.removeAllActions()
            releaseButton.removeFromParent()
            releaseAnimal()
            print("Animal released")
        }
        
        // Next button below pop up
        else if gameStatus == .finish && nextButtonMacacoPrego.contains(convert(pos, to: cam)) && instructionsStatus == .off {
            if let scene = GameScene2(fileNamed: "GameScene2") {
                 scene.scaleMode = .aspectFit
                 self.view!.presentScene(scene)
            }
            print("Next phase")
            audioPlayer?.stop()
        }
        
        // Jump when touches outside of left and right button
        else if jumpButton.contains(convert(pos, to: cam)) && instructionsStatus == .off {
            let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.1)
            jumpButton.run(fadeIn)
            jump()
            jumpStatus = .on
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
        
        if playerStatus == .walking && playerDirection == .left {
            xPlayerSpeed = 0
            playerStatus = .standing
            player.removeAllActions()
            leftButton.run(fadeOut)
            walkStatus = .off
        } else if playerStatus == .walking && playerDirection == .right {
            xPlayerSpeed = 0
            playerStatus = .standing
            player.removeAllActions()
            rightButton.run(fadeOut)
            walkStatus = .off
        } else if playerStatus == .jumping {
            playerStatus = .walking
            jumpButton.run(fadeOut)
        }
        
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
        // Delta time
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        // Delta time
        
        player.position.x += xPlayerSpeed * CGFloat(deltaTime)
        
        cam.position.x = player.position.x
        
        cam.position.y = (player.position.y) * 0.8 + 50
        
        if gameStatus == .finish {
            let moveCameraForPopUp = SKAction.move(to: CGPoint(x: macacoPrego.position.x - 250, y: macacoPrego.position.y + 250) , duration: 1)
            cam.run(moveCameraForPopUp)
            
            leftButton.removeFromParent()
            rightButton.removeFromParent()
            jumpButton.removeFromParent()
        }
        
        if playerStatus == .standing {
            player.texture = SKTexture(imageNamed: "curupira-standing")
            makePlayerDirection()
        }
        
        if jumpStatus == .on && walkStatus == .on {
            player.removeAllActions()
            let jumpTexture = SKTexture(imageNamed: "curupira-jump")
            player.texture = jumpTexture
        }
        
        if jumpStatus == .off && walkStatus == .off {
            player.texture = SKTexture(imageNamed: "curupira-standing")
            makePlayerDirection()
        }
    }
}
