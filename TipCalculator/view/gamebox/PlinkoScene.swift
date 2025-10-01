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
    // Konfeti renk paleti
    private let confettiColors: [SKColor] = [
        .systemPink, .systemYellow, .systemBlue, .systemGreen, .white
    ]

    // Çok sık tetiklenmesin diye basit debounce
    private var lastConfettiTime: CFTimeInterval = 0

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
        body.contactTestBitMask = 0b10 | 0b100   // box floor + pin

        
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
                pb.categoryBitMask = 0b100
                pb.contactTestBitMask = 0b01
                pin.physicsBody = pb
                pin.name = "pin"
                
                addChild(pin)
            }
        }
    }
    
    
    
    // MARK: - Realistic open-mouth boxes
    private func addRealisticBoxes() {
        let wallThickness: CGFloat = 8
        let boxHeight: CGFloat = 72
        let corner: CGFloat = 14
        
        // Kutuların oranlarını yüzdeye göre eşleştir
        // %10 → 0.35 (en büyük), %15 → 0.25, %25 → 0.2, %50 → 0.2 (en küçük)
        let config: [(percent: String, ratio: CGFloat, stroke: SKColor, fill: SKColor)] = [
            ("%10", 0.35, .systemBlue, .systemBlue.withAlphaComponent(0.15)),
            ("%15", 0.25, .systemGreen, .systemGreen.withAlphaComponent(0.15)),
            ("%25", 0.20, .systemYellow, .systemYellow.withAlphaComponent(0.15)),
            ("%50", 0.20, .systemPink, .systemPink.withAlphaComponent(0.15))
        ]
        
        var xOffset: CGFloat = 0
        
        for (i, item) in config.enumerated() {
            let width = size.width * item.ratio
            let centerX = xOffset + width / 2
            let floorY: CGFloat = boxHeight / 2
            
            // Panel
            let bodyRect = SKShapeNode(rectOf: CGSize(width: width, height: boxHeight + 12), cornerRadius: corner)
            bodyRect.position = CGPoint(x: centerX, y: floorY + (boxHeight / 2))
            bodyRect.fillColor = item.fill
            bodyRect.strokeColor = item.stroke
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
            
            // Label
            let label = SKLabelNode(text: item.percent)
            label.fontName = "SFProRounded-Bold"
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

        let nameA = nodeA.name ?? ""
        let nameB = nodeB.name ?? ""

        
        if (nameA == "ball" && nameB == "pin") || (nameB == "ball" && nameA == "pin") {
            Haptics.shared.tickPin()
            burstConfetti(at: contact.contactPoint, count: 10)
        }


        // === Kutu tabanına iniş
        let names = [nameA, nameB]
        guard names.contains("ball"),
              let boxName = names.first(where: { $0.hasPrefix("box") }) else { return }

        // 3 kısa titreşim
        Haptics.shared.tripleOnBox()

        dropTimeoutWorkItem?.cancel()

        let ball = (nameA == "ball") ? nodeA : nodeB
        if let pb = ball.physicsBody {
            pb.velocity = .zero
            pb.angularVelocity = 0
            pb.linearDamping = 10
            pb.restitution = 0
        }

        if let idxStr = boxName.dropFirst(3) as Substring?,
           let idx = Int(idxStr), idx >= 0, idx < boxPercents.count {
            let text = boxPercents[idx]
            bridge?.landingText = text
            bridge?.landingPercent = [10, 15, 25, 50][idx]
        }

        ball.removeFromParent()
        hasActiveBall = false
        activeBallNode = nil
        bridge?.isBallActive = false

        print("🎯 Top düştü: \(boxName)")
    }

    func burstConfetti(at point: CGPoint, count: Int = 12) {
        let now = CACurrentMediaTime()
        // aşırı spam'i engelle (örn. 25ms)
        guard now - lastConfettiTime > 0.025 else { return }
        lastConfettiTime = now

        // Parent node (kolay temizlemek için)
        let container = SKNode()
        container.position = point
        container.zPosition = 999 // üstte dursun
        addChild(container)

        for _ in 0..<count {
            // Kare konfeti (mini parça)
            let size = CGFloat.random(in: 3...6)
            let piece = SKShapeNode(rectOf: CGSize(width: size, height: size), cornerRadius: 0.8)
            piece.fillColor = confettiColors.randomElement() ?? .white
            piece.strokeColor = .clear
            piece.zRotation = CGFloat.random(in: 0...(CGFloat.pi))
            piece.alpha = 1.0

            // Başlangıç pozisyonuna hafif jitter
            piece.position = CGPoint(
                x: CGFloat.random(in: -3...3),
                y: CGFloat.random(in: -3...3)
            )

            container.addChild(piece)

            // Rastgele sıçrama vektörü (yukarı ağırlıklı)
            let dx = CGFloat.random(in: -110...110)
            let dy = CGFloat.random(in: 60...160)

            // Hareket (1.0 sn), rotasyon ve küçülme
            let move = SKAction.moveBy(x: dx, y: dy, duration: 1.0)
            move.timingMode = .easeOut   // hareketi canlı gözüksün

            let rotate = SKAction.rotate(byAngle: CGFloat.random(in: -2...2), duration: 1.0)

            let scale = SKAction.scale(to: 0.4, duration: 1.0)
            scale.timingMode = .easeIn   // kapanışta “içe” doğru

            // İstenen: 1 sn'de ease-in ile görünmez olsun
            let fade = SKAction.fadeOut(withDuration: 1.0)
            fade.timingMode = .easeIn

            // Hepsini birlikte çalıştır
            let group = SKAction.group([move, rotate, scale, fade])
            piece.run(.sequence([group, .removeFromParent()]))
        }

        // Container’ı da en geç 1.2s sonra kaldır
        container.run(.sequence([.wait(forDuration: 1.2), .removeFromParent()]))
    }
}
