//
//  FetchBirdRecordingUseCaseProtocol.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

 

import Foundation

protocol FetchBirdRecordingUseCaseProtocol: Sendable {
   
    func execute(
        scientificName: String,
         apiKey: String) async throws -> BirdRecording?
}
