//
//  RemoteConfig.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import Foundation

struct APIKeys : Sendable, Equatable {
    let inatToken : String?
    let xenoToken : String?
    
    var isApiKeysComplete: Bool {
        guard
            let iToken = inatToken, !iToken.isEmpty,
            let xToken = xenoToken, !xToken.isEmpty
        else {
            return false
        }
        return true
    }
}
