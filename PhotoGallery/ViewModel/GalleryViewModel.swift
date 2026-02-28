//
//  GalleryViewModel.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 28/02/26.
//

import SwiftUI
import Combine
import CoreData

@MainActor
class GalleryViewModel: ObservableObject {
    @Published var currentPage = 1
    @Published var images: [GalleryImage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let pageLimit = 20
    private var canLoadMore = true

    let container: NSPersistentContainer
    var service: Network

    public init(service: Network) {
        self.service = service
        container = NSPersistentContainer(name: "PhotoContainer")
        container.loadPersistentStores { description, error in
            if let error {
                print("Error loading core data \(error)")
            }
        }
    }

    // MARK: - Fetch

    func fetchImages() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            let request = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            let cached = try container.viewContext.fetch(request)

            if !cached.isEmpty {
                self.images = cached.map { $0.galleryImage }
                currentPage = (images.count / pageLimit) + 1
                isLoading = false
            } else {
                try await fetchFromNetwork()
            }
        } catch {
            errorMessage = "Failed to load photos: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func fetchNextPage() async {
        guard !isLoading, canLoadMore else { return }
        try? await fetchFromNetwork()
    }

    private func fetchFromNetwork() async throws {
        isLoading = true
        errorMessage = nil

        do {
            let endpoint = APIEndpoint.photos(page: currentPage, limit: pageLimit)
            let newImages: [GalleryImage] = try await service.fetch(from: endpoint.url)

            if newImages.count < pageLimit {
                canLoadMore = false
            }

            let existingIDs = Set(images.map { $0.id })
            let uniqueNew = newImages.filter { !existingIDs.contains($0.id) }
            images.append(contentsOf: uniqueNew)
            currentPage += 1

            // Save to Core Data
            for item in newImages {
                let entity = PhotoEntity(context: container.viewContext)
                entity.id = item.id
                entity.albumId = item.albumId
                entity.title = item.title
                entity.url = item.url
                entity.thumbnailUrl = item.thumbnailUrl
            }
            try container.viewContext.save()
        } catch {
            errorMessage = "Network error: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Update Title

    func updateTitle(id: Int64, title: String) {
        // Update in-memory
        if let index = images.firstIndex(where: { $0.id == id }) {
            images[index].title = title
        }

        // Update in Core Data
        let request = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        request.predicate = NSPredicate(format: "id == %lld", id)

        do {
            let results = try container.viewContext.fetch(request)
            if let entity = results.first {
                entity.title = title
                try container.viewContext.save()
            }
        } catch {
            errorMessage = "Failed to update title: \(error.localizedDescription)"
        }
    }

    // MARK: - Delete

    func deleteItem(id: Int64) {
        // Remove from in-memory array
        images.removeAll { $0.id == id }

        // Delete from Core Data
        let request = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        request.predicate = NSPredicate(format: "id == %lld", id)

        do {
            let results = try container.viewContext.fetch(request)
            for entity in results {
                container.viewContext.delete(entity)
            }
            try container.viewContext.save()
        } catch {
            errorMessage = "Failed to delete: \(error.localizedDescription)"
        }
    }
}
