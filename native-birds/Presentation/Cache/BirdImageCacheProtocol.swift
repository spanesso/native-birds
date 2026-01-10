//
//  BirdImageCacheProtocol.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//
import Foundation
import UIKit


protocol BirdImageCacheProtocol: Sendable {
    func image(for url: URL) async -> UIImage?
    
    func store(_ image: UIImage, for url: URL) async
}
