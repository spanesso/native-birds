//
//  AppError.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 10/01/26.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case missingINaturalistToken
    case missingLocation
    case locationFailed(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .missingINaturalistToken:
            return AppCopy.Error.missingINaturalistToken
        case .missingLocation:
            return AppCopy.Error.missingLocation
        case .locationFailed(let message):
            return message
        case .unknown(let message):
            return message
        }
    }
}
