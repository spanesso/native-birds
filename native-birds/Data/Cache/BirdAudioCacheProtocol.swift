//
//  BirdAudioCacheProtocol.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//
 
import Foundation

protocol BirdAudioCacheProtocol: Sendable {
    
    func fileURL( for remoteURL: URL) async -> URL?
    
    func storeDownloadedFile(
        from tempURL: URL,
        remoteURL: URL) async throws -> URL
}
