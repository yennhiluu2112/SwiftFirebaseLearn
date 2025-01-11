//
//  ProfileView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 22/12/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedPhoto: PhotosPickerItem? = nil

    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]
    
    private func isPreferenceSelected(text: String) -> Bool {
        return (viewModel.user?.preferences ?? [] ).contains(text)
    }
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("User id: \(user.uid)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("Is anonymous: \(isAnonymous.description.capitalized)")
                }
                
                Button(action: {
                    viewModel.togglePremiumStatus()
                }, label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                })
                
                VStack {
                    HStack {
                        ForEach(preferenceOptions, id: \.self) { string in
                            Button(action: {
                                if isPreferenceSelected(text: string) {
                                    viewModel.removeUserPreference(text: string)
                                } else {
                                    viewModel.addUserPreference(text: string)
                                }
                            }, label: {
                                Text(string)
                            })
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(isPreferenceSelected(text: string) ? .green : .red)
                        }
                    }
                    
                    Text("User preferences: \((user.preferences ?? []).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action: {
                    if user.favoriteMovie == nil {
                        viewModel.addFavoriteMovie()
                    } else {
                        viewModel.removeFavoriteMovie()
                    }
                }, label: {
                    Text("Favorite Movie: \(user.favoriteMovie?.title ?? "")")
                })
                
                PhotosPicker("Photo", 
                             selection: $selectedPhoto,
                             matching: .images,
                             photoLibrary: .shared())
                
                if let urlString = viewModel.user?.photoUrl,
                    let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                }
                
                if viewModel.user?.profileImagePath != nil {
                    Button(action: {
                        viewModel.deleteImage()
                    }, label: {
                        Text("Delete image")
                    })
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
        .onChange(of: selectedPhoto) { oldValue, newValue in
            if let newValue {
                viewModel.saveImage(item: newValue)
            }
        }
    }
}

#Preview {
    RootView()
}
