//
//  RouterProtocol.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import Foundation

@MainActor
protocol RouterProtocol: AnyObject {
    func push(_ route: AppRoute)
}
