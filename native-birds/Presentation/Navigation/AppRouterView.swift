//
//  AppRouterView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 7/01/26.
//

import SwiftUI

struct AppRouterView: View {
    
    @ObservedObject var router: AppRouter
    let container: DIContainer
    
    var body: some View {
        NavigationStack(path: $router.path){
            SplashView()
            
        }
    }
}
