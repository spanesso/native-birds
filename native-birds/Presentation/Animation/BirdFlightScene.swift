//
//  BirdFlightScene.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 11/01/26.
//

import SpriteKit

final class BirdFlightScene: SKScene {

    private var birdNode: SKSpriteNode!
    private let spriteSheetName: String

    init(size: CGSize, spriteSheetName: String) {
        self.spriteSheetName = spriteSheetName
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        createBird()
        startFlying()
    }

    private func createBird() {
        let texture = SKTexture(imageNamed: spriteSheetName)
        birdNode = SKSpriteNode(texture: texture)

        birdNode.size = CGSize( width:  140,
                                height: 100)

        birdNode.position = CGPoint(
            x:  size.width /  2,
            
            y: size.height / 2
        )

        birdNode.zPosition = 10
        
        addChild(birdNode)
    }

    private func startFlying() {
        let textures = loadTextures(
            
            columns: 3,
            rows: 3,
            textureName: spriteSheetName
        )

        let flyAction = SKAction.animate(
            with: textures,
            timePerFrame: 0.10,
            resize: false,
            restore: false
        )

        birdNode.run(.repeatForever(flyAction))
    }

    private func loadTextures(
        columns: Int,
         rows: Int,
        
        textureName: String
        
    ) -> [SKTexture] {

        let texture = SKTexture(imageNamed: textureName)
        let frameWidth = 1.0 / CGFloat(columns)
        
        let frameHeight = 1.0 / CGFloat(rows)

        var frames: [SKTexture] = []

        for row in 0..<rows {
            for column in 0..<columns {
                let rect = CGRect(
                    x: CGFloat(column) * frameWidth,
                    
                    y: CGFloat(rows - row - 1) * frameHeight,
                    
                    width: frameWidth,
                    height: frameHeight
                )

                frames.append(
                    SKTexture(rect: rect, in: texture)
                )
            }
        }

        return frames
    }
}
