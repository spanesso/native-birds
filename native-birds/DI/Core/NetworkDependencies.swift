//
//  NetworkDependencies.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//
import Foundation

final class NetworkDependencies {

    let client: URLSessionNetworkClient

    init() {
        self.client = URLSessionNetworkClient()
    }
}
