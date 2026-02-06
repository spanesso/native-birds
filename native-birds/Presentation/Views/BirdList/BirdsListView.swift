//
//  BirdsListView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import SwiftUI

struct BirdsListView: View {
    @StateObject var viewModel: BirdsListViewModel
    let imageCache: BirdImageCacheProtocol
    let router: RouterProtocol
    
    var body: some View {
        ZStack {
            BirdGradientBackground()
            
            switch viewModel.state {
                case .loaded, .loadingMore:
                    BirdsListContentView(
                        delegate: self,
                        birds: viewModel.birds,
                        state: viewModel.state,
                        canLoadMore: viewModel.canLoadMore,
                        imageCache: imageCache
                    )
                    
                case .idle, .loading:
                    BirdsListLoadingView(
                        text: AppCopy.BirdList.BirdListViewCopy.loading
                    )
                    
                case .empty:
                    BirdsListFeedbackView(
                        text: AppCopy.BirdList.BirdListViewCopy.empty,
                        actionTitle: AppCopy.Global.retry
                    ) {
                        Task { await viewModel.loadFirstPage() }
                    }
                    
                case .error(let message):
                    BirdsListFeedbackView(
                        text: message,
                        actionTitle: AppCopy.Global.retry
                    ) {
                        Task { await viewModel.loadFirstPage() }
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { viewModel.onAppear() }
    }
}

extension BirdsListView: BirdListViewDelegate {
    func onBirdSelected(_ bird: Bird) {
        router.push(.birdDetail(bird: bird))
    }
    
    func onAppearBird(_ bird: Bird) {
        viewModel.loadNextPageIfNeeded(currentItem: bird)
    }
    
    func onRetryPagination() {
        Task { await viewModel.loadNextPage() }
    }
    
    func onRefresh() async {
        await viewModel.loadFirstPage()
    }
}
