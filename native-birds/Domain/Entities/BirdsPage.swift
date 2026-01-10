//
//  BirdsPage.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 10/01/26.
//

import Foundation

struct BirdsPage: Sendable, Equatable {
    let birds: [Bird]
    let page: Int
    
    let perPage: Int
    
    let totalResults: Int

    var hasMore: Bool {
        (page * perPage) < totalResults
    }
}
