//
//  SplashViewModelTests.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import XCTest
import Combine
@testable import native_birds

@MainActor
final class SplashViewModelTests: XCTestCase {
    
    private var sut: SplashViewModel!
    private var router: MockRouter!
    private var remoteConfig: MockRemoteConfig!
    private var locationService: MockLocationService!
    
    override func setUp() {
        super.setUp()
        router = MockRouter()
        remoteConfig = MockRemoteConfig()
        locationService = MockLocationService()
        
        sut = SplashViewModel(
            router: router,
            remoteConfig: remoteConfig,
            locationService: locationService
        )
    }
    
    override func tearDown() {
        sut = nil
        router = nil
        remoteConfig = nil
        locationService = nil
        super.tearDown()
    }
    
    func test_onAppear_activatesRemoteConfig() async {
        sut.onAppear()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(remoteConfig.activateCalled)
    }
    
    func test_startAdventure_whenPermissionNotDeterminedAndGranted_navigatesToList() async {
        locationService.status = .authorized
        remoteConfig.apiKeys = APIKeys(inatToken: "valid", xenoToken: "valid")
        
        sut.startAdventureTapped()
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        XCTAssertTrue(locationService.requestAuthorizationCalled)
        XCTAssertEqual(sut.state, .readyToNavigate)
        XCTAssertEqual(router.pushedRoute, .birdList)
    }
    
    func test_startAdventure_whenPermissionDenied_showsModal() async {
        locationService.status = .denied
        
        sut.startAdventureTapped()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(sut.showDeniedModal)
        XCTAssertEqual(sut.state, .idle)
    }
    
    func test_startAdventure_whenKeysAreMissing_showsKeysModal() async {
        locationService.status = .authorized
        remoteConfig.apiKeys = APIKeys(inatToken: nil, xenoToken: nil)
        
        sut.startAdventureTapped()
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        XCTAssertTrue(sut.showKeysModal)
        XCTAssertEqual(sut.state, .idle)
    }
    
    func test_retryPermission_opensSettings() {
        sut.retryPermissionTapped()
        XCTAssertTrue(locationService.openAppSettingsCalled)
    }
}

final class MockRouter: RouterProtocol {
    var pushedRoute: AppRoute?
    
    func push(_ route: AppRoute) {
        pushedRoute = route
    }
}
