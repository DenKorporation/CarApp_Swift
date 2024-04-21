//
//  PreviewImage.swift
//  CarApp
//
//  Created by VMWare on 19.04.24.
//

import SwiftUI
import FirebaseStorage

struct PreviewImage: View {
    let path: String

    @State private var imageURL: URL?
    @State private var loading: Bool = true
    @State private var errorOccurred: Bool = false

    var body: some View {
        Group {
            if loading {
                LoadingView()
            } else if errorOccurred {
                Image("car_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
            } else if let imageURL = imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                } placeholder: {
                    LoadingView()
                }
            }
        }
        .onAppear {
            getFileUrl(from: path)
        }
    }

    private func getFileUrl(from firebasePath: String) {
        let storageRef = Storage.storage().reference(withPath: firebasePath)
        storageRef.downloadURL { url, error in
            if let url = url {
                self.imageURL = url
                self.loading = false
            } else {
                print("Failed with error: \(error?.localizedDescription ?? "unknown error")")
                self.errorOccurred = true
                self.loading = false
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .blue)) // Customize with your primary color
            .frame(width: 50, height: 50)
    }
}
