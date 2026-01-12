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
        ZStack(alignment: .bottom) {
            BirdHeroImage(
                url: bird.defaultPhotoMediumUrl,
                cache: imageCache
            )
            .ignoresSafeArea()
            
            
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.4), .clear, .clear]),
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
            
            
            BirdDetailBottomSheet(
                bird: bird,
                viewModel: viewModel,
                audioPlayer: audioPlayer
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    audioPlayer.stop()
                    onBack()
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .foregroundStyle(.white, .black.opacity(0.3))
                        .font(.title2)
                }
            }
        }
        .onAppear { viewModel.onAppear() }
    }
}

#Preview("Bird Detail") {
    
    let mockBird = Bird.preview(
        english: "Great Kiskadee",
        scientific: "Pitangus sulphuratus"
    )
    
    let mockRemoteConfig = MockRemoteConfig(ready: true)
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
