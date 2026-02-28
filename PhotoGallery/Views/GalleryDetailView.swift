//
//  GalleryDetailView.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 28/02/26.
//


import Kingfisher
import SwiftUI

struct GalleryDetailView: View {
    let image: GalleryImage
    var body: some View {
        VStack {
            if !image.thumbnailUrl.isEmpty, let url = URL(string: "https://picsum.photos/\(image.id)/\(image.albumId)") {
                KFImage(url)
                    .resizable()
                    .cacheOriginalImage()
                    .retry(maxCount: 3)
                    .placeholder {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(.rect(cornerRadius: 16))
            }
            Text(image.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                
            } label: {
                Text("Delete")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 56, alignment: .bottom)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 16))
            }
        }
        .padding()
        .navigationTitle("Photo Gallery")
    }
}

#Preview {
    GalleryDetailView(image: GalleryImage.mockImage)
}
