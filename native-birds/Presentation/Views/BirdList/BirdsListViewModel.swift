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
    
    @Published private(set) var currentPage: Int = 1
    
    @Published private(set) var canLoadMore: Bool = true

    private let locationService: LocationServiceProtocol
    private let remoteConfig: RemoteConfigProtocol
    private let fetchNearbyBirds: FetchNearbyBirdsUseCaseProtocol

    private let perPage: Int = 21
    private var isRequestInProcess: Bool = false

    init(
        locationService: LocationServiceProtocol,
        remoteConfig: RemoteConfigProtocol,
        fetchNearbyBirds: FetchNearbyBirdsUseCaseProtocol
    ) {
        self.locationService = locationService
        self.remoteConfig = remoteConfig
        self.fetchNearbyBirds = fetchNearbyBirds
    }

    func onAppear() {
        guard state == .idle else { return }
        Task { await loadFirstPage() }
    }

    func loadFirstPage() async {
        await performFetch(isFirstPage: true)
    }

    func loadNextPage() async {
        guard canLoadMore,
              (state == .loaded || state == .loadingMore) else {
            return
        }
        await performFetch(isFirstPage: false)
    }
 
    private func performFetch(isFirstPage: Bool) async {
        guard !isRequestInProcess else {
            return
        }
        
        isRequestInProcess = true
        defer { isRequestInProcess = false }
        
        prepareState(isFirstPage: isFirstPage)
        
        do {
            let coordinate = try await locationService.getCurrentCoordinates()
            let token = try await getValidatedToken()
            
            let targetPage = isFirstPage ? 1 : currentPage + 1
            
            let pageResult = try await fetchNearbyBirds.execute(
                lat: coordinate.latitude,
                lng: coordinate.longitude,
                page: targetPage,
                perPage: perPage,
                bearerToken: token
            )
            
            handleSuccess(result: pageResult, isFirstPage: isFirstPage, targetPage: targetPage)
            
        } catch {
            handleError(error, isFirstPage: isFirstPage)
        }
    }

    private func prepareState(isFirstPage: Bool) {
        if isFirstPage {
            state = .loading
            birds = []
            canLoadMore = true
        } else {
            state = .loadingMore
        }
    }

    private func getValidatedToken() async throws -> String {
        let keys = await remoteConfig.getAPIKeys()
        guard let token = keys.inatToken, !token.isEmpty else {
            throw LocationError.missingToken
        }
        return token
    }

    private func handleSuccess(result: BirdsPage, isFirstPage: Bool, targetPage: Int) {
        if isFirstPage {
            birds = result.birds
        } else {
            birds.append(contentsOf: result.birds)
        }
        
        currentPage = targetPage
        
        canLoadMore = result.hasMore
        
        state = birds.isEmpty ? .empty : .loaded
    }

    private func handleError(_ error: Error, isFirstPage: Bool) {
        
        
        if (error as? LocationError) == .missingToken {
            state = .error(AppCopy.Splash.RemoteConfig.missingKeysMessage)
            return
        }
        
        let message = isFirstPage
            ? "Unable to load nearby birds. Please try again."
        
            : "Unable to load more birds. Please try again."
        state = .error(message)
    }


    
    
    private enum LocationError: Error {
        
        case missingToken
    }
}

