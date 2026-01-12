//
//  AudioDownloadService.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import Foundation

final class AudioDownloadService: NSObject, AudioDownloadServiceProtocol, URLSessionDownloadDelegate {
    private let lock = NSLock()
    private var progressByTask: [Int: (@Sendable (Double) -> Void)] = [:]
    private var continuationByTask: [Int: CheckedContinuation<URL, Error>] = [:]
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func download(remoteURL: URL, onProgress: @escaping @Sendable (Double) -> Void) async throws -> URL {
        var finalURL = remoteURL
        if remoteURL.scheme == nil {
            if let sanitized = URL(string: "https:" + remoteURL.absoluteString) {
                finalURL = sanitized
            }
        }

        var request = URLRequest(url: finalURL)
        request.setValue("NativeBirdsApp/1.0 (iOS; Enterprise Technical Challenge)", forHTTPHeaderField: "User-Agent")
        
        return try await withCheckedThrowingContinuation { continuation in
            let task = session.downloadTask(with: request)
            
            lock.withLock {
                progressByTask[task.taskIdentifier] = onProgress
                continuationByTask[task.taskIdentifier] = continuation
            }
            task.resume()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite > 0 else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        
        lock.withLock {
            progressByTask[downloadTask.taskIdentifier]?(min(max(progress, 0), 1))
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let taskId = downloadTask.taskIdentifier
        
        let cont = lock.withLock { continuationByTask.removeValue(forKey: taskId) }
        guard let cont = cont else { return }
        
        let destination = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mp3")
        
        do {
            try FileManager.default.moveItem(at: location, to: destination)
            cleanup(taskId: taskId)
            cont.resume(returning: destination)
        } catch {
            cleanup(taskId: taskId)
            cont.resume(throwing: error)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let taskId = task.taskIdentifier
        
        if let error = error {
            let cont = lock.withLock { continuationByTask.removeValue(forKey: taskId) }
            cleanup(taskId: taskId)
            cont?.resume(throwing: error)
        }
    }
    
    private func cleanup(taskId: Int) {
        lock.withLock {
            progressByTask[taskId] = nil
            continuationByTask[taskId] = nil
        }
    }
}
