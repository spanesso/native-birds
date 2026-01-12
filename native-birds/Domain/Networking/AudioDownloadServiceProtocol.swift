//
//  AudioDownloadServiceProtocol.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import Foundation

protocol AudioDownloadServiceProtocol: Sendable {
    func download(remoteURL: URL, onProgress: @escaping @Sendable (Double) -> Void) async throws -> URL
}
