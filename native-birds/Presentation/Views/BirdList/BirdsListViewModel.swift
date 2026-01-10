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
    
    @Published private(set) var state : BirdsListUIState = .idle
    @Published private(set) var  birds : [Bird] = []
    @Published private(set) var currentPage: Int = 1
    
    @Published private(set)  var canLoadMore: Bool = true
    
    private let locationService: LocationServiceProtocol
    private let remoteConfig: RemoteConfigProtocol
    private let fetchNearbyBirds: FetchNearbyBirdsUseCaseProtocol
    
    private let perPage:  Int = 21
    
    private var isRequestInProcess: Bool = false
    
    private var cachedCoordinate: CLLocationCoordinate2D?
    
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
        guard state ==  .idle else {
            return
        }
        Task {
            await loadFirstPage()
        }
    }
    
    func loadFirstPage() async {
        await load(page: 1, isFirstPage: true)
    }
    
    func loadNextPage() async {
        guard canLoadMore else { return }
        await load(page: currentPage + 1, isFirstPage: false)
    }
    
    private func load(page: Int, isFirstPage: Bool) async {
        if isFirstPage {
            state = .loading
        } else {
            state = .loadingMore
        }
        
        do {
            let location = try await locationService.getCurrentCoordinates()
            let keys = await remoteConfig.getAPIKeys()
            guard let token = keys.inatToken, !token.isEmpty else {
                state = .error(AppCopy.Splash.RemoteConfig.missingKeysMessage)
                return
            }
            
            let result = try await fetchNearbyBirds.execute(
                lat: location.latitude,
                lng: location.longitude,
                page: page,
                perPage: 25,
                bearerToken: token
            )
            
            handleSuccess(result: result, isFirstPage: isFirstPage, targetPage: page)
            
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func loadNextPageIfNeeded(currentItem: Bird) {
        guard canLoadMore else { return }
        guard state == .loaded else {
            return }
        guard let last = birds.last, last == currentItem else {
            return
        }
        
        Task { await loadNextPage() }
    }
    
    private enum PageRequest {
        case first
        case next(currentPage: Int)
        
        var isFirst: Bool {
            if case .first = self {
                return true
            }
            return false
        }
        
        var targetPage: Int {
            switch self {
            case .first: return 1
                
            case .next(let currentPage): return currentPage + 1
            }
        }
    }
    
    private func performFetch(pageRequest: PageRequest) async {
        guard !isRequestInProcess else { return }
        isRequestInProcess = true
        defer { isRequestInProcess = false }
        
        prepareState(isFirstPage: pageRequest.isFirst)
        
        do {
            let coordinate = try await resolveCoordinate(isFirstPage: pageRequest.isFirst)
            
            
            let token = try await getValidatedToken()
            
            let pageResult = try await fetchNearbyBirds.execute(
                lat: coordinate.latitude,
                lng: coordinate.longitude,
                page: pageRequest.targetPage,
                perPage: perPage,
                bearerToken: token
            )
            
            handleSuccess(
                result: pageResult,
                isFirstPage: pageRequest.isFirst,
                targetPage: pageRequest.targetPage
            )
            
        } catch {
            handleError(error, isFirstPage: pageRequest.isFirst)
        }
    }
    
    private func resolveCoordinate(isFirstPage: Bool) async throws -> CLLocationCoordinate2D {
        if isFirstPage {
            cachedCoordinate = nil
        }
        
        if let cachedCoordinate {
            return cachedCoordinate
        }
        
        let coordinate = try await locationService.getCurrentCoordinates()
        cachedCoordinate = coordinate
        return coordinate
    }
    
    private func prepareState(isFirstPage: Bool) {
        if isFirstPage {
            state = .loading
            birds = []
            currentPage = 1
            canLoadMore = true
        } else {
            state = .loadingMore
        }
    }
    
    private func getValidatedToken() async throws -> String {
        let keys = await remoteConfig.getAPIKeys()
        
        let token = (keys.inatToken ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !token.isEmpty else {
            throw AppError.missingINaturalistToken
        }
        return token
    }
    
    private func handleSuccess(result: PagedResult<Bird>, isFirstPage: Bool, targetPage: Int) {
        if isFirstPage {
            birds = mergeDeduplicate(existing: [], incoming: result.items)
        } else {
            birds = mergeDeduplicate(existing: birds, incoming: result.items)
        }

        currentPage = targetPage
        canLoadMore = result.hasMore
        state = birds.isEmpty ? .empty : .loaded
    }
    
    private func mergeDeduplicate(
        existing: [Bird],
        incoming: [Bird]
    ) -> [Bird] {
        var indexByName: [String: Int] = [:]
        var result: [Bird] = []
        
        func score(_ bird: Bird) -> Int {
            var s = 0
            if bird.defaultPhotoUrl != nil { s += 1 }
            
            if bird.defaultPhotoMediumUrl != nil { s += 1 }
           
            if let common = bird.englishCommonName,
               !common.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { s += 1 }
            return s
        }
        
        func upsert(_ bird: Bird) {
            if let existingIndex = indexByName[bird.name] {
                let current = result[existingIndex]
                if score(bird) > score(current) {
                    result[existingIndex] = bird
                }
                
            } else {
                indexByName[bird.name] = result.count
                result.append(bird)
            }
        }
        
        existing.forEach(upsert)
        incoming.forEach(upsert)
        
        return result
    }
    
    
    
    private func handleError(_ error: Error, isFirstPage: Bool) {
        if !isFirstPage, !birds.isEmpty {
            state = .loaded
            return
        }
        state = .error(error.localizedDescription)
    }
}
