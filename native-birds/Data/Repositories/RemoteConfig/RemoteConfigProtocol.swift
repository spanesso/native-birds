//
//  RemoteConfigProtocol.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

protocol RemoteConfigProtocol :Sendable {
    
    func activate() async -> Bool
    
    func getAPIKeys() async -> APIKeys
    
}
