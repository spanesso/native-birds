//
//  AudioDownloadService.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import Foundation

protocol AudioDownloadServiceProtocol: Sendable {
    func download(remoteURL: URL, onProgress: @escaping @Sendable (Double) -> Void) async throws -> URL
}

final class AudioDownloadService: NSObject, AudioDownloadServiceProtocol, URLSessionDownloadDelegate {

    private var progressByTask: [Int: (@Sendable (Double) -> Void)] = [:]
    
    private var continuationByTask: [Int: CheckedContinuation<URL, Error>] = [:]
   
    private lazy var session: URLSession = {
        URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()

    func download(remoteURL: URL, onProgress: @escaping @Sendable (Double) -> Void) async throws -> URL {
        let request = URLRequest(url: remoteURL)

        return try await withCheckedThrowingContinuation { continuation in
            let task = session.downloadTask(with: request)
            
            progressByTask[task.taskIdentifier] = onProgress
            
            continuationByTask[
                task.taskIdentifier
            ] = continuation
            
            
            
            task.resume()
        }
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        guard totalBytesExpectedToWrite > 0 else {
            return
        }
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        progressByTask[downloadTask.taskIdentifier]?(min(max(progress, 0), 1))
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        

        guard let cont = continuationByTask[downloadTask.taskIdentifier] else {
            return
        }
        cleanup(taskId: downloadTask.taskIdentifier)
        cont.resume(returning: location)
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {

        guard let error else { return }
        guard let cont = continuationByTask[task.taskIdentifier] else {
            return }
        
        
        cleanup(taskId: task.taskIdentifier)
       
        
        cont.resume(throwing: error)
    }

    private func cleanup(taskId: Int) {
        progressByTask[taskId] = nil
        
        continuationByTask[taskId] = nil
    }
}
