//
//  GalleryImage.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 28/02/26.
//

import Foundation

struct GalleryImage: Identifiable, Codable {
    let id: Int64
    let albumId: Int64
    var title: String
    let url: String
    let thumbnailUrl: String
}

extension GalleryImage {
    static var mockImage: GalleryImage {
        GalleryImage(
            id: 1,
            albumId: 1,
            title: "Beautiful Landscapes",
            url: "https://picsum.photos/500",
            thumbnailUrl: "https://picsum.photos/800"
        )
    }
}
