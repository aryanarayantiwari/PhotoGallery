//
//  ContentView.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 26/02/26.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var viewModel = GalleryViewModel(service: NetworkService())
    @State private var showDeleteAlert = false
    @State private var itemToDelete: GalleryImage?

    var body: some View {
        NavigationView {
            Group {
                if viewModel.images.isEmpty && !viewModel.isLoading {
                    if let error = viewModel.errorMessage {
                        VStack(spacing: 16) {
                            Image(systemName: "wifi.exclamationmark")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text(error)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            Button("Retry") {
                                Task { await viewModel.fetchImages() }
                            }
                        }
                        .padding()
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("No photos found")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    List(viewModel.images) { item in
                        NavigationLink {
                            GalleryDetailView(image: item)
                        } label: {
                            GalleryImageView(image: item)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button("Delete", role: .destructive) {
                                        itemToDelete = item
                                        showDeleteAlert = true
                                    }
                                }
                                .task {
                                    if item.id == viewModel.images.last?.id {
                                        await viewModel.fetchNextPage()
                                    }
                                }
                        }
                    }
                    .listStyle(.inset)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .task {
                await viewModel.fetchImages()
            }
            .navigationTitle("Photo Gallery")
            .alert("Delete Photo", isPresented: $showDeleteAlert, presenting: itemToDelete) { item in
                Button("Delete", role: .destructive) {
                    viewModel.deleteItem(id: item.id)
                }
                Button("Cancel", role: .cancel) {}
            } message: { item in
                Text("Are you sure you want to delete \"\(item.title)\"?")
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
