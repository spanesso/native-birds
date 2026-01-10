//
//  BirdImageCache.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation
import UIKit

actor BirdImageCache: BirdImageCacheProtocol {

    private let cacheMem = NSCache<NSURL, UIImage>()
    private let ttl: TimeInterval = 60 * 60 * 24 * 15

    private let folderURL: URL

    init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        folderURL = caches.appendingPathComponent("BirdImages", isDirectory: true)
        try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
    }
    
    private func filePath(for url: URL) -> URL {
        let name = sha256(url.absoluteString)
        return folderURL.appendingPathComponent("\(name).jpg")
    }
    
    

    func image(for url: URL) async -> UIImage? {
        if let img = cacheMem.object(forKey: url as NSURL) {
            return img
        }
        
        

        let fileURL = filePath(for: url)

        guard let attrs = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
              let modified = attrs[.modificationDate] as? Date
        else {
            return nil
        }

        if Date().timeIntervalSince(modified) > ttl {
            try? FileManager.default.removeItem(at: fileURL)
            return nil
        }
        
        

        guard let data = try? Data(contentsOf: fileURL),
              let img = UIImage(data: data)
        else {
            return nil
            
        }

        cacheMem.setObject(img, forKey: url as NSURL)
        return img
    }

    func store(_ image: UIImage, for url: URL) async {
        cacheMem.setObject(image, forKey: url as NSURL)

        let fileURL = filePath(for: url)
        
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            return
        }
        try? data.write(to: fileURL, options: [.atomic])
    }

   

    private func sha256(_ input: String) -> String {
        return String(input.hashValue.magnitude, radix: 16)
    }
}
