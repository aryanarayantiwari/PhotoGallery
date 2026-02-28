//
//  GalleryViewModel.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 28/02/26.
//

import SwiftUI
import Combine

class GalleryViewModel: ObservableObject {
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
