//
//  BirdFlightSceneTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import SpriteKit
@testable import native_birds

final class BirdFlightSceneTests: XCTestCase {
    
    private var sut: BirdFlightScene!
    private let sceneSize = CGSize(width: 300, height: 200)
    private let spriteName = "test_sprite"
    
    override func setUp() {
        super.setUp()
        sut = BirdFlightScene(size: sceneSize, spriteSheetName: spriteName)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_init_shouldSetCorrectProperties() {
        XCTAssertEqual(sut.size, sceneSize)
        XCTAssertEqual(sut.scaleMode, .resizeFill)
        XCTAssertEqual(sut.backgroundColor, .clear)
    }
    
    func test_didMoveToView_shouldCreateBirdNode() {
        let view = SKView()
        sut.didMove(to: view)
        
        let birdNode = sut.children.first as? SKSpriteNode
        
        XCTAssertNotNil(birdNode)
        XCTAssertEqual(birdNode?.zPosition, 10)
        XCTAssertEqual(birdNode?.position, CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2))
    }
    
    func test_birdNode_shouldHaveExpectedSize() {
        let view = SKView()
        sut.didMove(to: view)
        
        let birdNode = sut.children.first as? SKSpriteNode
        
        XCTAssertEqual(birdNode?.size.width, 140)
        XCTAssertEqual(birdNode?.size.height, 100)
    }
}
