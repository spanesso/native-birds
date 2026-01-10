//
//  BirdsListViewModel.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation
import CoreLocation
internal import Combine

@MainActor
final class BirdsListViewModel: ObservableObject {

    @Published private(set) var state: BirdsListUIState = .idle
    @Published private(set) var birds: [Bird] = []
    

    init(
        locationService: LocationServiceProtocol,
        remoteConfig: RemoteConfigProtocol,
        fetchNearbyBirds: FetchNearbyBirdsUseCaseProtocol
    ) {
        self.locationService = locationService
        self.remoteConfig = remoteConfig
        self.fetchNearbyBirds = fetchNearbyBirds
    }

   
}
