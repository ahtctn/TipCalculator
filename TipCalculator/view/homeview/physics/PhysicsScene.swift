//
//  PhysicsScene.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//


import SpriteKit
import CoreMotion

class PhysicsScene: SKScene {
    let motionManager = CMMotionManager()
    var onBubbleTap: ((Int) -> Void)?
    private var selectedBubble: SKShapeNode?
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: size))
        physicsBody?.restitution = 0.2
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        startDeviceMotion()
    }
    
    
    func startDeviceMotion() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion else { return }
            
            let gravityX = motion.gravity.x * 9.8
            let gravityY = -motion.gravity.y * -9.8
            self?.physicsWorld.gravity = CGVector(dx: gravityX, dy: gravityY)
        }
    }
    
    func addBubble(percent: Int, radius: CGFloat, position: CGPoint) {
        let bubble = SKShapeNode(circleOfRadius: radius)
        bubble.position = position
        bubble.fillColor = .white.withAlphaComponent(0.2)
        bubble.strokeColor = .white
        bubble.lineWidth = 4
        bubble.name = "bubble_\(percent)"
        
        // Yüzde yazısı
        let label = SKLabelNode(text: "%\(percent)")
        label.fontName = "Helvetica-Bold"
        label.fontSize = radius * 0.6
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        bubble.addChild(label)
        
        let body = SKPhysicsBody(circleOfRadius: radius)
        body.restitution = 0.5
        body.friction = 0.1
        body.linearDamping = 0.4
        body.affectedByGravity = true
        
        bubble.physicsBody = body
        addChild(bubble)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let tapped = atPoint(location)
        
        let bubbleNode: SKShapeNode?
        if let shape = tapped as? SKShapeNode, shape.name?.starts(with: "bubble_") == true {
            bubbleNode = shape
        } else if let parent = tapped.parent as? SKShapeNode, parent.name?.starts(with: "bubble_") == true {
            bubbleNode = parent
        } else {
            bubbleNode = nil
        }

        guard let bubble = bubbleNode,
              let name = bubble.name,
              let percent = Int(name.replacingOccurrences(of: "bubble_", with: "")) else { return }

        if bubble == selectedBubble {
            // 👇 Aynı bubble'a ikinci kez basıldıysa deselect yap
            bubble.fillColor = .white.withAlphaComponent(0.2)
            bubble.strokeColor = .white
            selectedBubble = nil

            // Animasyon: hafif geri çekilme
            let deselect = SKAction.sequence([
                .scale(to: 0.9, duration: 0.1),
                .scale(to: 1.0, duration: 0.1)
            ])
            bubble.run(deselect)

            // Geri bildirim: %0 tip
            onBubbleTap?(0)
            return
        }

        // Yeni seçim → varsa öncekini sıfırla
        if let prev = selectedBubble {
            prev.fillColor = .white.withAlphaComponent(0.2)
            prev.strokeColor = .white
        }

        bubble.strokeColor = .systemPink
        selectedBubble = bubble

        // Bounce animasyon
        let bounce = SKAction.sequence([
            .scale(to: 1.2, duration: 0.1),
            .scale(to: 0.9, duration: 0.1),
            .scale(to: 1.0, duration: 0.1)
        ])
        bubble.run(bounce)

        onBubbleTap?(percent)
    }

    
    
    
}