//
//  PlinkoScene.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.09.2025.
//


import SpriteKit

class PlinkoScene: SKScene, SKPhysicsContactDelegate {
    
    weak var bridge: SceneBridge?
    
    private let ballRadius: CGFloat = 15
    private let boxHeights: CGFloat = 60
    private var hasBooted = false
    private var hasActiveBall = false
    private var activeBallNode: SKNode?
    private var dropTimeoutWorkItem: DispatchWorkItem?
    
    // Slot → gösterilecek yüzde metni
    private let boxPercents = ["%10", "%15", "%25", "%50"]
    
    func bootIfNeeded() {
        guard !hasBooted else { return }
        hasBooted = true
        
        backgroundColor = .clear
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        physicsWorld.contactDelegate = self
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // sınırlar
        physicsBody?.isDynamic = false
        
        addPinsCentered(rows: 6, cols: 6)
        addRealisticBoxes()
    }
    
    func resetAll() {
        dropTimeoutWorkItem?.cancel()
        removeAllChildren()
        physicsBody = nil
        hasActiveBall = false
        activeBallNode = nil
        bridge?.isBallActive = false
        bridge?.landingText = nil
        hasBooted = false
        bootIfNeeded()
    }
    
    // MARK: - Public: Tek top bırak
    func dropBall() {
        guard hasBooted, hasActiveBall == false else { return }
        hasActiveBall = true
        bridge?.isBallActive = true
        bridge?.landingText = nil
        addBall()
        armDropTimeout()
    }
    
    // MARK: - Ball
    private func addBall() {
        let ball = SKShapeNode(circleOfRadius: ballRadius)
        ball.fillColor = .orange
        ball.strokeColor = .clear
        
        let x = CGFloat.random(in: size.width * 0.35 ... size.width * 0.65)
        ball.position = CGPoint(x: x, y: size.height - 50)
        ball.name = "ball"
        
        let body = SKPhysicsBody(circleOfRadius: ballRadius)
        body.restitution = 0.6
        body.friction = 0
        body.linearDamping = 0
        body.angularDamping = 0
        body.allowsRotation = true
        body.categoryBitMask = 0b01
        body.collisionBitMask = 0xFFFFFFFF
        body.contactTestBitMask = 0b10        // box floor ile teması dinle
        
        ball.physicsBody = body
        addChild(ball)
        activeBallNode = ball
        
        // hafif dürtme
        ball.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -5...5), dy: 0))
    }
    
    private func armDropTimeout() {
        dropTimeoutWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            if self.hasActiveBall {
                self.activeBallNode?.removeFromParent()
                self.activeBallNode = nil
                self.hasActiveBall = false
                self.bridge?.isBallActive = false
                self.bridge?.landingText = "—" // failsafe info (isteğe bağlı)
            }
        }
        dropTimeoutWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: work)
    }
    
    // MARK: - Pins (6×6, ortada, glow)
    private func addPinsCentered(rows: Int, cols: Int) {
        let gridWidth  = size.width * 0.8
        let gridHeight = size.height * 0.45
        
        let hSpacing = gridWidth / CGFloat(max(cols - 1, 1))
        let vSpacing = gridHeight / CGFloat(max(rows - 1, 1))
        
        // grid’in toplam genişliği (stagger dahil)
        let totalWidth = CGFloat(cols - 1) * hSpacing + (hSpacing / 2)
        let startX = (size.width - totalWidth) / 2
        let startY = size.height - (size.height * 0.15) - gridHeight
        
        for row in 0..<rows {
            for col in 0..<cols {
                let offsetX = (row % 2 == 0) ? hSpacing/2 : 0
                let x = startX + CGFloat(col) * hSpacing + offsetX
                let y = startY + CGFloat(row) * vSpacing
                
                let r: CGFloat = 6
                let pin = SKShapeNode(circleOfRadius: r)
                pin.fillColor = SKColor.systemPink.withAlphaComponent(0.9) 
                pin.strokeColor = .clear
                pin.glowWidth = 6
                pin.zPosition = 5
                pin.position = CGPoint(x: x, y: y)
                
                let pb = SKPhysicsBody(circleOfRadius: r)
                pb.isDynamic = false
                pb.restitution = 0.0
                pb.friction = 0.0
                pin.physicsBody = pb
                
                addChild(pin)
            }
        }
    }
    
    
    
    // MARK: - Realistic open-mouth boxes
    private func addRealisticBoxes() {
        let ratios: [CGFloat] = [0.2, 0.2, 0.3, 0.3]
        let wallThickness: CGFloat = 8
        let boxHeight: CGFloat = 72
        let corner: CGFloat = 14
        
        let strokes: [SKColor] = [
            .systemBlue, .systemGreen, .systemYellow, .systemPink
        ]
        let fills: [SKColor] = [
            .systemBlue.withAlphaComponent(0.15),
            .systemGreen.withAlphaComponent(0.15),
            .systemYellow.withAlphaComponent(0.15),
            .systemPink.withAlphaComponent(0.15)
        ]
        
        var xOffset: CGFloat = 0
        
        for (i, ratio) in ratios.enumerated() {
            let width = size.width * ratio
            let centerX = xOffset + width / 2
            let floorY: CGFloat = boxHeight / 2
            
            // Panel
            let bodyRect = SKShapeNode(rectOf: CGSize(width: width, height: boxHeight + 12), cornerRadius: corner)
            bodyRect.position = CGPoint(x: centerX, y: floorY + (boxHeight / 2))
            bodyRect.fillColor = fills[i]
            bodyRect.strokeColor = strokes[i]
            bodyRect.lineWidth = 2
            bodyRect.zPosition = 2
            bodyRect.glowWidth = 4
            addChild(bodyRect)
            
            // Floor
            let floor = SKNode()
            floor.position = CGPoint(x: centerX, y: floorY)
            let fb = SKPhysicsBody(rectangleOf: CGSize(width: width - wallThickness*0.5, height: wallThickness))
            fb.isDynamic = false
            fb.categoryBitMask = 0b10
            fb.contactTestBitMask = 0b01
            floor.physicsBody = fb
            floor.name = "box\(i)"
            addChild(floor)
            
            // Walls
            let leftWall = SKNode()
            leftWall.position = CGPoint(x: xOffset + wallThickness/2, y: floorY + boxHeight/2)
            let lb = SKPhysicsBody(rectangleOf: CGSize(width: wallThickness, height: boxHeight))
            lb.isDynamic = false
            leftWall.physicsBody = lb
            addChild(leftWall)
            
            let rightWall = SKNode()
            rightWall.position = CGPoint(x: xOffset + width - wallThickness/2, y: floorY + boxHeight/2)
            let rb = SKPhysicsBody(rectangleOf: CGSize(width: wallThickness, height: boxHeight))
            rb.isDynamic = false
            rightWall.physicsBody = rb
            addChild(rightWall)
            
            // Label (bold & tek sefer)
            let label = SKLabelNode(text: boxPercents[i])
            label.fontName = ".SFUI-Bold"
            label.fontSize = 22
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            label.fontColor = .white
            label.position = CGPoint(x: centerX, y: floorY + boxHeight/2)
            label.zPosition = 5
            addChild(label)
            
            xOffset += width
        }
    }
    
    // MARK: - Contact
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node else { return }
        
        let names = [nodeA.name ?? "", nodeB.name ?? ""]
        guard names.contains("ball"),
              let boxName = names.first(where: { $0.hasPrefix("box") }) else { return }
        
        dropTimeoutWorkItem?.cancel()
        
        let ball = (nodeA.name == "ball") ? nodeA : nodeB
        if let pb = ball.physicsBody {
            pb.velocity = .zero
            pb.angularVelocity = 0
            pb.linearDamping = 10
            pb.restitution = 0
        }
        
        // Hangi kutu → hangi yüzde
        if let idxStr = boxName.dropFirst(3) as Substring?,
           let idx = Int(idxStr), idx >= 0, idx < boxPercents.count {
            let text = boxPercents[idx]
            bridge?.landingText = text
            bridge?.landingPercent = [10, 15, 25, 50][idx]   // 🔥 numeric yüzde
        }
        
        // Topu kaldır (kutuda bırakmak istersen burayı yorumla)
        ball.removeFromParent()
        
        hasActiveBall = false
        activeBallNode = nil
        bridge?.isBallActive = false
        
        print("🎯 Top düştü: \(boxName)")
    }
}
