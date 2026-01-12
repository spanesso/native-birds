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
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        
                        Text(AppCopy.BirdList.BirdListViewCopy.title)
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundStyle(BirdTheme.deepBlack)
                            .padding(.horizontal, BirdSpacing.screenHorizontal)
                            .padding(.top, 6)
                        
                        LazyVStack(spacing: 14) {
                            ForEach(viewModel.birds, id: \.name) { bird in
                                BirdListItem(bird: bird, cache: imageCache)
                                    .padding(.horizontal, BirdSpacing.screenHorizontal)
                                    .onAppear {
                                        viewModel.loadNextPageIfNeeded(currentItem: bird)
                                    }
                                    .onTapGesture {
                                        router.push(.birdDetail(bird: bird))
                                    }
                            }
                            
                            footerPaginationView
                        }
                        
                        .padding(.bottom, 16)
                    }
                }
                .refreshable {
                    await viewModel.loadNextPage()
                }
                
                
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
    
    @ViewBuilder
    private var footerPaginationView: some View {
        if viewModel.canLoadMore {
            if viewModel.state == .loadingMore {
                ProgressView()
                    .padding(.vertical, 14)
            } else {
                BirdButton(title: AppCopy.Global.retry, state: .normal) {
                    Task { await viewModel.loadNextPage() }
                }
                .padding(.horizontal, BirdSpacing.screenHorizontal)
                .padding(.vertical, 8)
                .opacity(0.0001)
            }
        } else {
            EmptyView()
        }
    }
}

#if DEBUG

#Preview("Idle") {
    BirdsListView(
        viewModel: makeBirdsListViewModel(state: .idle),
        imageCache: MockBirdImageCache(),
        router: MockRouter()
    )
}

#Preview("Loading") {
    BirdsListView(
        viewModel: makeBirdsListViewModel(state: .loading),
        imageCache: MockBirdImageCache(),
        router: MockRouter()
    )
}

#Preview("Loaded") {
    BirdsListView(
        viewModel: makeBirdsListViewModel(
            state: .loaded,
            birds: Bird.mockList(),
            canLoadMore: true
        ),
        imageCache: MockBirdImageCache(),
        router: MockRouter()
    )
}

#Preview("Loading More") {
    BirdsListView(
        viewModel: makeBirdsListViewModel(
            state: .loadingMore,
            birds: Bird.mockList(),
            canLoadMore: true
        ),
        imageCache: MockBirdImageCache(),
        router: MockRouter()
    )
}

#Preview("Empty") {
    BirdsListView(
        viewModel: makeBirdsListViewModel(state: .empty),
        imageCache: MockBirdImageCache(),
        router: MockRouter()
    )
}

#Preview("Error") {
    BirdsListView(
        viewModel: makeBirdsListViewModel(
            state: .error("Something went wrong")
        ),
        imageCache: MockBirdImageCache(),
        router: MockRouter()
    )
}

#endif
