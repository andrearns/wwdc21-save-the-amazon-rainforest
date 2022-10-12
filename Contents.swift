/*:
 
# Save the Amazon Rainforest
 
This is an immersive game in the Amazon Rainforest that aims to teach people, specially kids, about the wonderful animals that are at risk of extinction and show the reality that they face nowadays. The adventure is guided by Curupira, a folkloric figure from Brazil known for being the protector of forests, who wants to save animals from trafficking and forest fire.
 
---
## Instructions
---
 
 1) Please perform in full screen landscape and use the arrows in the bottom of the screen to control the character.
 
 2) For better experience use a headphone and enjoy the sounds.
 
___
 
 - Important: Please **disable results** of the Playgrounds by clicking on the speed icon on the left side of "Run my code". The app won't run if you don't do this.
 
---
 
## Enjoy the adventure!
 
*/

//#-hidden-code
import PlaygroundSupport
import SpriteKit

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 860, height: 640))
if let scene = Intro(fileNamed: "Intro") {
    
    scene.scaleMode = .aspectFit
    
    sceneView.isMultipleTouchEnabled = true
    
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code
