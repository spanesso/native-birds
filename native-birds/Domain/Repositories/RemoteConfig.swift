//
//  RemoteConfig.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

struct APIKeys :Sendable {
    let inatToken : String?
    let xenoToken : String?
}

protocol RemoteConfigProtocol :Sendable {
    
    func activate() async -> Bool
    
    func getAPIKeys() async -> APIKeys
    
}
