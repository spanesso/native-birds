//
//  BirdAudioCache.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//


import Foundation
 
actor BirdAudioCache: BirdAudioCacheProtocol {

    private let ttl: TimeInterval = 60 * 60 * 24 * 15

     private let disk: DiskTTLCache

    init() {
         self.disk = DiskTTLCache(folderName: "BirdAudio", ttl: ttl)
    }

    func fileURL(for remoteURL: URL) async -> URL? {
         let fileURL = await disk.fileURL(for: remoteURL.absoluteString, fileExtension: "mp3")

         await disk.removeIfExpired(fileURL)

         return await disk.exists(fileURL) ? fileURL : nil
    }

    func storeDownloadedFile(from tempURL: URL, remoteURL: URL) async throws -> URL {
         let destination = await disk.fileURL(for: remoteURL.absoluteString, fileExtension: "mp3")

        if await disk.exists(destination) {
            await disk.remove(destination)
        }

        try FileManager.default.moveItem(at: tempURL, to: destination)

         await disk.touch(destination)

        return destination
    }
}
