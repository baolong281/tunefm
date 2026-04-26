//
//  ProfilePhotoPicker.swift
//  tunefm
//
//  Created by dylan h on 4/25/26.
//
import SwiftUI
import PhotosUI

// reusable profile photo picker component
// used in create account + profile change
// parent passes their imageData and profile Image state for us to alter
struct ProfilePhotoPicker: View {
    @Binding var imageData: Data?
    @Binding var profileImage: Image?
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var showCamera = false
    
    var body: some View {
        VStack(spacing: 12) {
            // show photo in circle, otherwise gray square it nothing
            if let profileImage {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Circle()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.appSurfaceMuted)
            }
            
            VStack(spacing: 12) {
                // library button
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Text("Select photo from library")
                        .font(.appBody)
                        .foregroundStyle(Color.appAccent)
                }
                
                // camera button
                // initiate CameraView in sheet
                Button {
                    showCamera = true
                } label: {
                    Text("Take new photo")
                        .font(.appBody)
                        .foregroundStyle(Color.appAccent)
                }
            }
            .foregroundColor(.primary)
        }
        .onChange(of: selectedPhoto) { _, newValue in
            guard let newItem = newValue else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.imageData = data
                        self.profileImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
        // present the CameraView from uikit as a sheet
        .sheet(isPresented: $showCamera) {
            CameraView { uiImage in
                self.imageData = uiImage.jpegData(compressionQuality: 0.8) // we need the data from this
                self.profileImage = Image(uiImage: uiImage)
            }
        }
    }
}
