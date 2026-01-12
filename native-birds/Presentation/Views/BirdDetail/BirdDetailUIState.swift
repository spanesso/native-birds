//
//  BirdDetailUIState.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import Foundation

enum BirdDetailUIState: Equatable {
    case idle
    case loading
    case loaded(recording: BirdRecording?)
    case error(String)
}

enum BirdAudioUIState: Equatable {
    case idle
    case downloading( progress: Double)
    case ready(localFileURL : URL)
    case playing (localFileURL: URL)
    
    case paused(localFileURL : URL)
    
    case error( String )
}
