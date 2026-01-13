//
//  BirdRecording.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

struct BirdRecording: Hashable, Sendable{
    let id: String
    let genus: String
    let species: String
    let commonName: String
    let audioUrl: String
    let quality: String
    let type: String
    let duration: String
}
