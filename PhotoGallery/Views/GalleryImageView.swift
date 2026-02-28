//
//  GalleryImageView.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 28/02/26.
//

import SwiftUI
import Kingfisher

struct GalleryImageView: View {
    let image: GalleryImage
    var body: some View {
        HStack {
            if !image.thumbnailUrl.isEmpty, let url = URL(string: "https://picsum.photos/id/\(image.id)/200/200") {
                KFImage(url)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .retry(maxCount: 3)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44, alignment: .center)
            }
            Text(image.title)
                .font(.caption)
                .frame(alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    GalleryImageView(image: GalleryImage.mockImage)
}
