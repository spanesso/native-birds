//
//  Untitled.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//

protocol BirdDataMergerProtocol: Sendable {
    func mergeAndDeduplicate(existing: [Bird], incoming: [Bird]) -> [Bird]
}

struct BirdDataMerger: BirdDataMergerProtocol {
    func mergeAndDeduplicate(existing: [Bird], incoming: [Bird]) -> [Bird] {
        var indexByName: [String: Int] = [:]
        var result: [Bird] = []

        func score(_ bird: Bird) -> Int {
            var score = 0
            if bird.defaultPhotoUrl != nil { score += 1 }
            if bird.defaultPhotoMediumUrl != nil { score += 1 }
            if let common = bird.preferredCommonName, !common.isEmpty { score += 1 }
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
