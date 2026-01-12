//
//  BirdDetailView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//
import SwiftUI

struct BirdDetailView: View {
    let bird: Bird
    let imageCache: BirdImageCacheProtocol
    @StateObject var viewModel: BirdDetailViewModel
    @StateObject private var audioPlayer = BirdAudioPlayer()
    
    let onBack: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            BirdHeroImage(url: bird.defaultPhotoMediumUrl, cache: imageCache)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(0)
            
            LinearGradient(
                colors: [.black.opacity(0.5), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 150)
            .ignoresSafeArea()
            .zIndex(1)
            
            BirdBackButton(action: onBack)
                .zIndex(2)
            
            VStack {
                Spacer()
                BirdDetailBottomSheet(
                    bird: bird,
                    viewModel: viewModel,
                    audioPlayer: audioPlayer
                )
            }
            .zIndex(3)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { viewModel.onAppear() }
    }
}

#Preview("Bird Detail") {
    
    let mockBird = Bird.preview(
        english: "Great Kiskadee",
        scientific: "Pitangus sulphuratus"
    )
    
    let mockRemoteConfig = MockRemoteConfig()
    
    mockRemoteConfig.apiKeys = APIKeys(inatToken: "mock", xenoToken: "mock")
    
    let mockImageCache = MockImageCache()
    
    let viewModel = BirdDetailViewModel(
        bird: mockBird,
        remoteConfig: mockRemoteConfig,
        fetchRecording: MockFetchRecording(),
        audioCache: MockAudioCache(),
        downloader: MockDownloader()
    )
    
    return NavigationStack {
        BirdDetailView(
            bird: mockBird,
            imageCache: mockImageCache,
            viewModel: viewModel,
            onBack: { }
        )
    }
}
