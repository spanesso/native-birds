//
//  BirdDetailViewModel.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//


import Foundation

@MainActor
final class BirdDetailViewModel: ObservableObject {
    
    @Published private(set) var state: BirdDetailUIState = .idle
    @Published private(set) var audioState: BirdAudioUIState = .idle
    
    
}
