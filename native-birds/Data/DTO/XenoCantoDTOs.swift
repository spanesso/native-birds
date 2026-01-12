//
//  XenoCantoDTOs.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import Foundation

struct XenoCantoRecordingsResponseDTO: Decodable, Sendable {
    
    let recordings:  [XenoCantoRecordingDTO]
}

struct XenoCantoRecordingDTO: Decodable, Sendable {
    let  id:  String
    let species:  XenoCantoSpeciesDTO
    
    let audio: XenoCantoAudioDTO
}

struct XenoCantoSpeciesDTO:  Decodable, Sendable {
    let genus: String
    let species: String
    
    let commonName: String
}

struct XenoCantoAudioDTO: Decodable,
                            Sendable {
    let url: String
   
    let quality: String
    let type: String
    let  duration: String
}

enum XenoCantoMapper {
    static func map(dto: XenoCantoRecordingDTO) -> BirdRecording {
        BirdRecording(
            id: dto.id,
            
            genus:  dto.species.genus,
            species: dto.species.species,
            commonName:  dto.species.commonName,
            audioUrl:  dto.audio.url,
           
            quality: dto.audio.quality,
            type: dto.audio.type,
            duration: dto.audio.duration
        )
    }
}
