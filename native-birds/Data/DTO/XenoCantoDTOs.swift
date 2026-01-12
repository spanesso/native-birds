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
    let id: String
    let file: String
    let gen: String
    let sp: String
    let en: String
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
            genus: dto.gen,
            species: dto.sp,
            commonName: dto.en,
            audioUrl: dto.file,
            quality: "unknown",
            type: "sound",
            duration: "0"
        )
    }
}
