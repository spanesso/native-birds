//
//  PagedResult.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 10/01/26.
//

import Foundation

struct PagedResult<T: Sendable>: Sendable {
    let items: [T]
    
    let hasMore: Bool
    

    init(items: [T], hasMore: Bool) {
        self.items = items
        self.hasMore = hasMore
    }
}
