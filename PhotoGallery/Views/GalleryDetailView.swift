//
//  GalleryDetailView.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 28/02/26.
//


import Kingfisher
import SwiftUI

struct GalleryDetailView: View {
    @EnvironmentObject private var viewModel: GalleryViewModel
    @Environment(\.dismiss) private var dismiss
    let image: GalleryImage
    @State private var title = ""
    @State private var showDeleteAlert = false

    var body: some View {
        VStack {
            if !image.thumbnailUrl.isEmpty, let url = URL(string: image.thumbnailUrl) {
                KFImage(url)
                    .resizable()
                    .cacheOriginalImage()
                    .retry(maxCount: 3)
                    .placeholder {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            TextField("Title", text: $title)
        }
        .onAppear {
            title = image.title
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    viewModel.updateTitle(id: image.id, title: title)
                    dismiss()
                } label: {
                    Text("Save")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 56, alignment: .bottom)
                        .background(Color.primary)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                Button {
                    showDeleteAlert = true
                } label: {
                    Text("Delete")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 56, alignment: .bottom)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .padding()
        .navigationTitle(image.title)
        .alert("Delete Photo", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteItem(id: image.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this photo?")
        }
    }
}

#Preview {
    GalleryDetailView(image: GalleryImage.mockImage)
}
