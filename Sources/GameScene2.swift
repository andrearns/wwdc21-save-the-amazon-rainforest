import AVFoundation
import SpriteKit
import UIKit

public class GameScene2: SKScene, SKPhysicsContactDelegate {
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
//    var jumpAnimation: SKAction!
    
    // Life
    var life: Int = 5
    var lifePoint1: SKSpriteNode!
    var lifePoint2: SKSpriteNode!
    var lifePoint3: SKSpriteNode!
    var lifePoint4: SKSpriteNode!
    var lifePoint5: SKSpriteNode!
    
    // Animals
    var araraAzul: SKSpriteNode!
    
    // Pop ups
    var araraAzulPopUp: SKSpriteNode!
    var araraAzulNextButton: SKSpriteNode!
    var overlay: SKSpriteNode!
    var popUpAnimation: SKAction!
    
    // Initial instructions
    var instructionsOverlay: SKSpriteNode!
    var instructionsStatus: InstructionsState = .on
    var tapToStart: SKLabelNode!
    var instructionsText: SKSpriteNode!
    
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
    
    // Game Over
    var gameOverLabel: SKSpriteNode!
    var tryAgainButton: SKSpriteNode!
    
    // Bear Trap
    var bearTrap1: SKSpriteNode!
    var bearTrapGraphic1: SKSpriteNode!
    let bearTrapBody1 = SKPhysicsBody(rectangleOf: CGSize(width: 120, height: 20))
    var bearTrap2: SKSpriteNode!
    var bearTrapGraphic2: SKSpriteNode!
    let bearTrapBody2 = SKPhysicsBody(rectangleOf: CGSize(width: 120, height: 20))
    var bearTrapAnimation: SKAction!
    
    // Release button
    var releaseButton: SKSpriteNode!
    
    // Background
    var background: SKSpriteNode!
    
    // Spawns
    var actualSpawn = CGPoint(x: 0, y: 0)
    var spawn1: SKSpriteNode!
    var spawn2: SKSpriteNode!
    var spawn3: SKSpriteNode!
    var spawn4: SKSpriteNode!
    var spawn5: SKSpriteNode!
    var spawn6: SKSpriteNode!
    
    // Talk
    var talkPlace: SKSpriteNode!
    var conversation: SKSpriteNode!
    
    // Sounds
    var audioPlayer: AVAudioPlayer?
    let lockSound = SKAction.playSoundFileNamed("lock-sound", waitForCompletion: true)
    let bearTrapSound = SKAction.playSoundFileNamed("beartrap", waitForCompletion: true)
    let hurtSound = SKAction.playSoundFileNamed("hurt", waitForCompletion: true)
    
    // Used in delta time
    var lastUpdate = TimeInterval()
    
    override public func didMove(to view: SKView) {
        // Add camera on the scene
        self.camera = cam
        cam.setScale(1.2)
        addChild(cam)
        
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
        
        // Add animal on the scene
        araraAzul = self.childNode(withName: "AraraAzul") as? SKSpriteNode
        araraAzul.texture = SKTexture(imageNamed: "araraazul-jaula")
        
        // Add key on the scene
        key = self.childNode(withName: "Key") as? SKSpriteNode
        keyGlow = self.childNode(withName: "KeyGlow") as? SKSpriteNode
        setupKeyGlowAnimation()
        keyGlow.run(keyGlowAnimation)
        
        // Add release button of the animals on the scene
        releaseButton = self.childNode(withName: "ReleaseButton") as? SKSpriteNode
        
        // Add bear trap on the scene
        bearTrap1 = self.childNode(withName: "BearTrap1") as? SKSpriteNode
        bearTrapBody1.categoryBitMask = 8
        bearTrapBody1.collisionBitMask = 0
        bearTrapBody1.contactTestBitMask = 0
        bearTrapBody1.allowsRotation = false
        bearTrapBody1.affectedByGravity = false
        bearTrap1.physicsBody = bearTrapBody1
        bearTrapGraphic1 = bearTrap1.childNode(withName: "BearTrapGraphic1") as? SKSpriteNode
        
        bearTrap2 = self.childNode(withName: "BearTrap2") as? SKSpriteNode
        bearTrapBody2.categoryBitMask = 8
        bearTrapBody2.collisionBitMask = 0
        bearTrapBody2.contactTestBitMask = 0
        bearTrapBody2.allowsRotation = false
        bearTrapBody2.affectedByGravity = false
        bearTrap2.physicsBody = bearTrapBody2
        bearTrapGraphic2 = bearTrap2.childNode(withName: "BearTrapGraphic2") as? SKSpriteNode
        
        setupBearTrap()
        
        
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
        
        // Add pop up on the scene
        araraAzulPopUp = SKSpriteNode(imageNamed: "araraazul-popup")
        araraAzulPopUp.setScale(0.75)
        araraAzulPopUp.alpha = 0
        araraAzulPopUp.zPosition = 1000
        araraAzulPopUp.position = CGPoint(x: -45, y: 50)
        
        araraAzulNextButton = SKSpriteNode(imageNamed: "araraazul-nextbutton")
        araraAzulNextButton.setScale(1)
        araraAzulNextButton.alpha = 0
        araraAzulNextButton.zPosition = 1000
        araraAzulNextButton.position = CGPoint(x: -45, y: -200)
        
        overlay = SKSpriteNode(color: UIColor.black, size: self.size)
        overlay.alpha = 0
        
        cam.addChild(overlay)
        cam.addChild(araraAzulPopUp)
        cam.addChild(araraAzulNextButton)
        
        // Add game over elements on the scene
        gameOverLabel = SKSpriteNode(imageNamed: "gameover-label")
        gameOverLabel.alpha = 0
        gameOverLabel.zPosition = 1000
        gameOverLabel.setScale(1)
        gameOverLabel.position = CGPoint(x: 0, y: 30)
        
        tryAgainButton = SKSpriteNode(imageNamed: "tryagain-button")
        tryAgainButton.alpha = 0
        tryAgainButton.zPosition = 1000
        tryAgainButton.position = CGPoint(x: 0, y: -50)
        
        cam.addChild(gameOverLabel)
        cam.addChild(tryAgainButton)
        
        // Instructions
        instructionsOverlay = SKSpriteNode(color: UIColor.black, size: self.size)
        instructionsOverlay.alpha = 0.7
        instructionsOverlay.zPosition = 999
        cam.addChild(instructionsOverlay)
        
        instructionsText = self.childNode(withName: "InstructionsText") as? SKSpriteNode
        instructionsText.zPosition = 1001
        
        tapToStart = self.childNode(withName: "TapToStart") as? SKLabelNode
        tapToStart.zPosition = 1001
        
        // Spawns
        spawn1 = self.childNode(withName: "Spawn1") as? SKSpriteNode
        spawn2 = self.childNode(withName: "Spawn2") as? SKSpriteNode
        spawn3 = self.childNode(withName: "Spawn3") as? SKSpriteNode
        spawn4 = self.childNode(withName: "Spawn4") as? SKSpriteNode
        spawn5 = self.childNode(withName: "Spawn5") as? SKSpriteNode
        spawn6 = self.childNode(withName: "Spawn6") as? SKSpriteNode
        
        // Talk
        conversation = SKSpriteNode(imageNamed: "curupiratalks1")
        conversation.position.x = 170
        conversation.position.y = player.position.y + 170
        conversation.setScale(0.4)
        conversation.alpha = 0
        cam.addChild(conversation)
        
        talkPlace = self.childNode(withName: "TalkPlace") as? SKSpriteNode
        
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
    
    func setupBearTrap() {
        // Bear trap animation fired when player touches

        var bearTrapList = [SKTexture]()

        for i in 1...4 {
            bearTrapList.append(SKTexture(imageNamed: "urso\(i)"))
        }

        bearTrapAnimation = SKAction.animate(with: bearTrapList, timePerFrame: 0.1)
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
        
        araraAzul.texture = SKTexture(imageNamed: "araraazul-livre")
        araraAzul.zPosition = 999
        cam.position = CGPoint(x: 0, y: 200)
        
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
        
        araraAzulPopUp.run(SKAction.sequence([delay, fadeInPopUp]))
        overlay.run(SKAction.sequence([delay, fadeInOverlay]))
        araraAzulNextButton.run(SKAction.sequence([delay, fadeInPopUp]))
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
    
    func hurt() {
        print("Player got hurt")
        life = life - 1
        checkLifeStatus()
        print("Life:\(life)")
        run(hurtSound)
    }
    
    func gameOver() {
        gameStatus = .over
            
        player.removeAllActions()
        xPlayerSpeed = 0
        
        overlay.run(SKAction.fadeAlpha(to: 0.7, duration: 1))
        gameOverLabel.run(SKAction.fadeAlpha(to: 1, duration: 1))
        tryAgainButton.run(SKAction.fadeAlpha(to: 1, duration: 1))
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
    
    func talk() {
        let talkDuration = SKAction.wait(forDuration: 4)
        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.5)
        
        conversation.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        conversation.run(SKAction.sequence([talkDuration, fadeOut]))
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        // Function to report when an object touches another
        if contact.bodyA.node?.name == "BearTrap1" || contact.bodyB.node?.name == "BearTrap1" {
            run(bearTrapSound)
            hurt()
            bearTrapGraphic1.run(bearTrapAnimation)
            bearTrapBody1.categoryBitMask = 0
            bearTrapBody1.collisionBitMask = 0
            bearTrapBody1.contactTestBitMask = 0
        }
        else if contact.bodyA.node?.name == "BearTrap2" || contact.bodyB.node?.name == "BearTrap2" {
            run(bearTrapSound)
            hurt()
            bearTrapGraphic2.run(bearTrapAnimation)
            bearTrapBody2.categoryBitMask = 0
            bearTrapBody2.collisionBitMask = 0
            bearTrapBody2.contactTestBitMask = 0
        }
        else if contact.bodyA.node?.name == "PierceTrap" || contact.bodyB.node?.name == "PierceTrap" {
            hurt()
            player.run(SKAction.fadeAlpha(to: 0, duration: 0))
            player.run(SKAction.move(to: actualSpawn, duration: 0))
            player.run(SKAction.fadeAlpha(to: 100, duration: 1))
        }
        else if contact.bodyA.node?.name == "Key" || contact.bodyB.node?.name == "Key" {
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
        else if contact.bodyA.node?.name == "TalkPlace" || contact.bodyB.node?.name == "TalkPlace" {
            print("Reached talk place")
            talk()
        }
        else if contact.bodyA.node?.name == "Spawn1" || contact.bodyB.node?.name == "Spawn1" {
            print("Reached spawn 1")
            actualSpawn = spawn1.position
        } else if contact.bodyA.node?.name == "Spawn2" || contact.bodyB.node?.name == "Spawn2" {
            print("Reached spawn 2")
            actualSpawn = spawn2.position
        } else if contact.bodyA.node?.name == "Spawn3" || contact.bodyB.node?.name == "Spawn3" {
            print("Reached spawn 3")
            actualSpawn = spawn3.position
        } else if contact.bodyA.node?.name == "Spawn4" || contact.bodyB.node?.name == "Spawn4" {
            print("Reached spawn 4")
            actualSpawn = spawn4.position
        } else if contact.bodyA.node?.name == "Spawn5" || contact.bodyB.node?.name == "Spawn5" {
            print("Reached spawn 5")
            actualSpawn = spawn5.position
        } else if contact.bodyA.node?.name == "Spawn6" || contact.bodyB.node?.name == "Spawn6" {
            print("Reached spawn 6")
            actualSpawn = spawn6.position
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
            instructionsStatus = .off
            fadeOutInstructions()
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
        else if releaseButton.contains(pos) && keyStatus == .found && instructionsStatus == .off{
            releaseButton.removeAllActions()
            releaseButton.removeFromParent()
            releaseAnimal()
            print("Animal released")
        }
        
        // Next button below pop up
        else if gameStatus == .finish && araraAzulNextButton.contains(convert(pos, to: cam)) && instructionsStatus == .off {
            if let scene = JungleFire1(fileNamed: "JungleFire1") {
                 scene.scaleMode = .aspectFit
                 self.view!.presentScene(scene)
            }
            print("Next phase")
            audioPlayer?.stop()
        }
        
        // Try again button on the game over screen
        else if tryAgainButton.contains(convert(pos, to: cam)) && instructionsStatus == .off && gameStatus == .over {
            tryAgainButton.removeFromParent()
            if let scene = GameScene2(fileNamed: "GameScene2") {
                 scene.scaleMode = .aspectFit
                 self.view!.presentScene(scene)
            }
            print("Restart phase")
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
        
        if life == 0 {
            gameOver()
        }
        
        if gameStatus == .finish {
            araraAzul.position.x = player.position.x - 20
            araraAzul.position.y = player.position.y + 25
            araraAzul.xScale = -0.2
            let moveCameraForPopUp = SKAction.move(to: CGPoint(x: araraAzul.position.x - 200, y: araraAzul.position.y + 200) , duration: 1)
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

