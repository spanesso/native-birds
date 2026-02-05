//
//  BirdsListContentView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//

import SwiftUI

struct BirdsListContentView: View {
    let birds: [Bird]
    let state: BirdsListUIState
    let canLoadMore: Bool
    let imageCache: BirdImageCacheProtocol
    
    let onBirdSelected: (Bird) -> Void
    let onAppearBird: (Bird) -> Void
    let onRetryPagination: () -> Void
    let onRefresh: () async -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BirdSpacing.screenHorizontal) {
                
                BirdLabel(
                    text: AppCopy.BirdList.BirdListViewCopy.title,
                    style: .title
                )
                .padding(.horizontal, BirdSpacing.screenHorizontal)
                .padding(.top, 6)

                LazyVStack(spacing: BirdSpacing.listItemPadding) {
                    ForEach(birds, id: \.taxonId) { bird in
                        BirdListItem(bird: bird, cache: imageCache)
                            .padding(.horizontal, BirdSpacing.screenHorizontal)
                            .onAppear {
                                onAppearBird(bird)
                            }
                            .onTapGesture {
                                onBirdSelected(bird)
                            }
                    }
                    
                    paginationFooter
                }
                .padding(.bottom, BirdSpacing.screenHorizontal)
            }
        }
        .refreshable {
            await onRefresh()
        }
    }

    @ViewBuilder
    private var paginationFooter: some View {
        if canLoadMore {
            if state == .loadingMore {
                ProgressView()
                    .padding(.vertical, 14)
            } else {
                BirdButton(title: AppCopy.Global.retry, state: .normal) {
                    onRetryPagination()
                }
                .padding(.horizontal, BirdSpacing.screenHorizontal)
                .padding(.vertical, 8)
                .opacity(0.001)
            }
        }
    }
}


#Preview("Loaded - Full State") {
    BirdsListContentView(
        birds: Bird.mockList(),
        state: .loaded,
        canLoadMore: true,
        imageCache: MockBirdImageCache(),
        onBirdSelected: { bird in print("Selected: \(bird.name)") },
        onAppearBird: { bird in print("Appeared: \(bird.name)") },
        onRetryPagination: {},
        onRefresh: {}
    )
    .background(BirdGradientBackground())
}

#Preview("Loading More - Pagination") {
    BirdsListContentView(
        birds: Array(Bird.mockList().prefix(3)),
        state: .loadingMore,
        canLoadMore: true,
        imageCache: MockBirdImageCache(),
        onBirdSelected: { _ in },
        onAppearBird: { _ in },
        onRetryPagination: {},
        onRefresh: {}
    )
    .background(BirdGradientBackground())
}

#Preview("Last Page - No More Data") {
    BirdsListContentView(
        birds: Array(Bird.mockList().prefix(5)),
        state: .loaded,
        canLoadMore: false,
        imageCache: MockBirdImageCache(),
        onBirdSelected: { _ in },
        onAppearBird: { _ in },
        onRetryPagination: {},
        onRefresh: {}
    )
    .background(BirdGradientBackground())
}
