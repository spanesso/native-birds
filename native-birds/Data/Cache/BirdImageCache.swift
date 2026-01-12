//
//  BirdImageCache.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 10/01/26.
//
//

import Foundation
import UIKit

actor BirdImageCache: BirdImageCacheProtocol {

    private let memory = NSCache<NSURL, UIImage>()
    private let ttl: TimeInterval = 60 * 60 * 24 * 15

     private let disk: DiskTTLCache

    init() {
         self.disk = DiskTTLCache(folderName: "BirdImages", ttl: ttl)
    }

    func image(for url: URL) async -> UIImage? {
        if let img = memory.object(forKey: url as NSURL) {
            return img
        }

         let fileURL = await disk.fileURL(for: url.absoluteString, fileExtension: "jpg")

         await disk.removeIfExpired(fileURL)

         guard await disk.exists(fileURL) else {
            return nil
        }

        guard let data = try? Data(contentsOf: fileURL),
              let img = UIImage(data: data) else {
            return nil
        }

        memory.setObject(img, forKey: url as NSURL)
        return img
    }

    func store(_ image: UIImage, for url: URL) async {
        memory.setObject(image, forKey: url as NSURL)

         let fileURL = await disk.fileURL(for: url.absoluteString, fileExtension: "jpg")

        guard let data = image.jpegData(compressionQuality: 0.9) else {
            return
        }

        try? data.write(
            to: fileURL,
            options: [.atomic]
        )

         await disk.touch(fileURL)
    }
}
