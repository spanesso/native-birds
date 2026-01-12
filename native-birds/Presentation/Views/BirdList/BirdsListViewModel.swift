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
    private var isRequestInProcess = false
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
        guard state == .idle else { return }
        Task { await loadFirstPage() }
    }

    func loadFirstPage() async {
        await performFetch(.first)
    }

    func loadNextPage() async {
        guard canLoadMore else { return }
        await performFetch(.next(currentPage: currentPage))
    }

    func loadNextPageIfNeeded(currentItem: Bird) {
        guard
            state == .loaded,
            canLoadMore,
            birds.last == currentItem
        else { return }

        Task { await loadNextPage() }
    }

    private enum PageRequest {
        case first
        case next(currentPage: Int)

        var isFirstPage: Bool {
            if case .first = self { return true }
            return false
        }

        var targetPage: Int {
            switch self {
            case .first:
                return 1
            case .next(let currentPage):
                return currentPage + 1
            }
        }
    }

    private func performFetch(_ request: PageRequest) async {
        guard !isRequestInProcess else { return }
        isRequestInProcess = true
        defer { isRequestInProcess = false }

        prepareState(isFirstPage: request.isFirstPage)

        do {
            let coordinate = try await resolveCoordinate(isFirstPage: request.isFirstPage)
            let token = try await validatedToken()

            let pageResult = try await fetchNearbyBirds.execute(
                
                lat: coordinate.latitude,
                lng: coordinate.longitude,
                
                page:  request.targetPage,
                perPage: perPage,
                bearerToken: token
            )

            handleSuccess(
                result:  pageResult,
                 isFirstPage: request.isFirstPage,
                targetPage: request.targetPage
            )

        } catch {
            
            handleError(
                error,
                isFirstPage: request.isFirstPage
            )
        }
    }

    private func prepareState(isFirstPage: Bool) {
        if isFirstPage {
            state = .loading
            birds = []
            currentPage = 1
            canLoadMore = true
            cachedCoordinate = nil
        } else {
            state = .loadingMore
        }
    }

    private func resolveCoordinate(isFirstPage: Bool) async throws -> CLLocationCoordinate2D {
        if let cachedCoordinate { return cachedCoordinate }
        let coordinate = try await locationService.getCurrentCoordinates()
        cachedCoordinate = coordinate
        return coordinate
    }

    private func validatedToken() async throws -> String {
        let keys = await remoteConfig.getAPIKeys()
        let token = (keys.inatToken ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !token.isEmpty else {
            throw AppError.missingINaturalistToken
        }
        return token
    }

    private func handleSuccess(
        result: PagedResult<Bird>,
        isFirstPage: Bool,
        targetPage: Int
    ) {
        birds = mergeDeduplicate(
            existing: isFirstPage ? [] : birds,
            incoming: result.items
        )

        currentPage = targetPage
        canLoadMore = result.hasMore
        state = birds.isEmpty ? .empty : .loaded
    }

    private func handleError(_ error: Error, isFirstPage: Bool) {
        if !isFirstPage, !birds.isEmpty {
            state = .loaded
        } else {
            state = .error(error.localizedDescription)
        }
    }

    private func mergeDeduplicate(
        existing: [Bird],
        incoming: [Bird]
    ) -> [Bird] {

        var indexByName: [String: Int] = [:]
        var result: [Bird] = []

        func score(_ bird: Bird) -> Int {
            var score = 0
            if bird.defaultPhotoUrl != nil { score += 1 }
            if bird.defaultPhotoMediumUrl != nil { score += 1 }
            if let common = bird.preferredCommonName,
               !common.trimmingCharacters(in: .whitespaces).isEmpty {
                score += 1
            }
            return score
        }

        func upsert(_ bird: Bird) {
            if let index = indexByName[bird.name] {
                if score(bird) > score(result[index]) {
                    result[index] = bird
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
}


#if DEBUG
extension BirdsListViewModel {
    @MainActor
    func _setPreview(
        state: BirdsListUIState,
        birds: [Bird] = [],
        canLoadMore: Bool = false
    ) {
        self.state = state
        self.birds = birds
        self.canLoadMore = canLoadMore
    }
}
#endif

