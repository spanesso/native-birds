//
//  AppCopy.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation

enum AppCopy {
    
    enum Global {
        
        static let cancel =
        "Cancel"
        
        static let retry =
        "Retry"
        
    }
    
    enum Splash {
        
        enum SplashViewCopy {
            static let title =
            "Native Birds"
            
            static let subTitle =
            "Discover and listen to the world of birds"
            
            
        }
        
        enum RemoteConfig {
            static let missingKeysTitle =
            "Configuration Incomplete"
            
            static let missingKeysMessage =
            "Required keys from Remote Config are missing. Please verify your Firebase Remote Config configuration and try again."
            
        }
        
        enum Location {
            static let permissionRequiredTitle =
            "Location Permission Required"
            
            static let permissionRequiredMessage =
            "BirdSongs needs access to your location to show nearby birds. Please enable GPS permissions to continue."
            
            
        }
        
        enum Actions {
            static let startAdventure =
            "Start Adventure"
        }
    }
    
    enum BirdList {
        
        enum BirdListViewCopy {
            static let title =
            "Nearby Birds"
            
            static let subTitle =
            "Discover and listen to the world of birds"
            
            static let loading =
            "Loading nearby birds..."
            
            
            
            static let empty =
            "No birds found nearby."
            
            
            
        }
    }
}
