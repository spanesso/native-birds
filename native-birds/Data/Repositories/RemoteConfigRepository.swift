//
//  RemoteConfigRepository.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import Foundation
import FirebaseRemoteConfig
import FirebaseCore

final class RemoteConfigRepository: RemoteConfigProtocol {
    
    private let remoteConfig: RemoteConfig
    private var storageKeys =  APIKeys (
        inatToken : nil,
        xenoToken : nil
    )
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    func activate() async -> Bool {
        do {
            let status = try await remoteConfig.fetchAndActivate()
            refreshCache()
            return status == .successFetchedFromRemote || status == .successUsingPreFetchedData
        } catch {
            return false
        }
    }
    
    func getAPIKeys() async -> APIKeys {
        return storageKeys
    }
    
    private func refreshCache() {
        let inatoken = remoteConfig["inat_bearer_token"].stringValue
        let xenotoken = remoteConfig["xeno_canto_key"].stringValue
        
        storageKeys = APIKeys(inatToken: inatoken, xenoToken: xenotoken)
    }
}
