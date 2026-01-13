//
//  AppRouter.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import SwiftUI
internal import Combine

@MainActor
final class AppRouter: ObservableObject,RouterProtocol {
    @Published var path: [AppRoute] = []
    
    func push(_ route : AppRoute){
        if path.last == route {
            return
        }
        path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }
}
