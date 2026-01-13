//
//  BirdsListUIState.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation

enum BirdsListUIState: Equatable {
    case idle
    case loading
    case loadingMore
    case loaded
    case empty
    case error(String)
}
