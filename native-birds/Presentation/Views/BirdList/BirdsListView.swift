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
                VStack(spacing: 12) {
                    ProgressView()
                    BirdLabel(text: AppCopy.BirdList.BirdListViewCopy.loading, style: .body)
                }
                
                
            case .empty:
                VStack(spacing: 10) {
                    BirdLabel(text: AppCopy.BirdList.BirdListViewCopy.empty, style: .body)
                    BirdButton(title: AppCopy.Global.retry, state: .normal) {
                        Task { await viewModel.loadFirstPage() }
                    }
                    .padding(.horizontal, BirdSpacing.screenHorizontal)
                }
                
            case .error(let message):
                VStack(spacing: 10) {
                    BirdLabel(text: message, style: .body)
                    BirdButton(title: AppCopy.Global.retry, state: .normal) {
                        Task { await viewModel.loadFirstPage() }
                    }
                    .padding(.horizontal, BirdSpacing.screenHorizontal)
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
