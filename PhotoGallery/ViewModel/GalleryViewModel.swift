//
//  GalleryViewModel.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 28/02/26.
//

import SwiftUI
import Combine
import CoreData

class GalleryViewModel: ObservableObject {
    @Published var currentPage = 0
    var pageCount = 0
    var totalPages = 0
    
    @Published var imagesToDisplay: [GalleryImage] = []
    
    @Published var images: [GalleryImage] = []
    @Published var isLoading: Bool = false

    var service: Network

    public init(service: Network) {
        self.service = service
    }
    func fetchImages() async {
        isLoading = true
        do {
            images = try await service.fetch(session: URLSession.shared)
        } catch {
            print(error)
        }
        isLoading = false
    }
}
