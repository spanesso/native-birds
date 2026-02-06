//
//  BirdsListContentView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 5/02/26.
//

import SwiftUI

protocol BirdListViewDelegate {
    func onBirdSelected(_ bird: Bird)
    func onAppearBird(_ bird: Bird)
    func onRetryPagination()
    func onRefresh() async
}

struct BirdsListContentView: View {
    let delegate: BirdListViewDelegate
    let birds: [Bird]
    let state: BirdsListUIState
    let canLoadMore: Bool
    let imageCache: BirdImageCacheProtocol

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
                                delegate.onAppearBird(bird)
                            }
                            .onTapGesture {
                                delegate.onBirdSelected(bird)
                            }
                    }
                    
                    paginationFooter
                }
                .padding(.bottom, BirdSpacing.screenHorizontal)
            }
        }
        .refreshable {
            await delegate.onRefresh()
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
                    delegate.onRetryPagination()
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
        delegate:BirdListViewDelegateMock(),
        birds: Bird.mockList(),
        state: .loaded,
        canLoadMore: true,
        imageCache: MockBirdImageCache()
    )
    .background(BirdGradientBackground())
}

#Preview("Loading More - Pagination") {
    BirdsListContentView(
        delegate:BirdListViewDelegateMock(),
        birds: Array(Bird.mockList().prefix(3)),
        state: .loadingMore,
        canLoadMore: true,
        imageCache: MockBirdImageCache()
    )
    .background(BirdGradientBackground())
}

#Preview("Last Page - No More Data") {
    BirdsListContentView(
        delegate:BirdListViewDelegateMock(),
        birds: Array(Bird.mockList().prefix(5)),
        state: .loaded,
        canLoadMore: false,
        imageCache: MockBirdImageCache()
    )
    .background(BirdGradientBackground())
}
