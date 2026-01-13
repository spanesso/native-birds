//
//  DiskTTLCache.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import Foundation

actor DiskTTLCache {

    private let ttl: TimeInterval
    private let folderURL: URL

    init(folderName: String, ttl: TimeInterval) {
        self.ttl = ttl

        let caches = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first!

        self.folderURL = caches.appendingPathComponent(
            folderName,
            isDirectory: true
        )

        try? FileManager.default.createDirectory(
            at: folderURL,
            withIntermediateDirectories: true
        )
    }

    func fileURL(for key: String, fileExtension: String) -> URL {
        let name = hash(key)
        return folderURL
            .appendingPathComponent("\(name).\(fileExtension)")
    }

    func isFresh(_ fileURL: URL) -> Bool {
        guard let attrs = try? FileManager
            .default.attributesOfItem(
            atPath: fileURL.path
        ),
        let modified =  attrs[.modificationDate] as?
                Date else {
            return false
        }

        return Date().timeIntervalSince(modified)
        <= ttl
    }

    func removeIfExpired(_ fileURL: URL) {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }

        if !isFresh(fileURL) {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }

    func touch(_ fileURL: URL) {
        try? FileManager.default.setAttributes(
            [.modificationDate: Date()],
            ofItemAtPath: fileURL.path
        )
    }

    func exists(_ fileURL: URL) -> Bool {
        FileManager.default.fileExists(atPath: fileURL.path)
    }

    func remove(_ fileURL: URL) {
        try? FileManager.default.removeItem(at: fileURL)
    }

    private func hash(_ input: String) -> String {
        return String(input.hashValue.magnitude, radix: 16)
    }
}
