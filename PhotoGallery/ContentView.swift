//
//  ContentView.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 26/02/26.
//

import SwiftUI
import Foundation
import Combine

struct ContentView: View {
    @StateObject private var viewModel = GalleryViewModel(service: NetworkService())
    var body: some View {
        NavigationView {
            List(viewModel.images) { item in
                NavigationLink {
                    GalleryDetailView(image: item)
                } label: {
                    GalleryImageView(image: item)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button("Delete", role: .destructive) {
                                
                            }
                        })
                }
            }
            .listStyle(.inset)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .task {
               await viewModel.fetchImages()
            }
            .navigationTitle("Photo Gallery")
        }
    }
}

#Preview {
    ContentView()
}
