//
//  DIContainer.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

@MainActor
final class DIContainer{
    
    let remoteConfig : RemoteConfigRepository
    
    private init(remoteConfig: RemoteConfigRepository) {
        self.remoteConfig = remoteConfig
    }
    
    static func construct() -> DIContainer {
        let remoteConfig = RemoteconfigImpl()
        
        
        return DIContainer(
            remoteConfig: remoteConfig
        )
    }
    
}
