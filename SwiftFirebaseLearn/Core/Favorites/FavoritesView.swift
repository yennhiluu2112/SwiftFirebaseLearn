//
//  FavoritesView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 29/12/24.
//

import SwiftUI

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []

    func getAllFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let userFavoriteProducts = try await  UserManager.shared.getUserFavoriteProducts(uid: authDataResult.uid)
            self.userFavoriteProducts = userFavoriteProducts
        }
    }
    
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()

            try await UserManager.shared.removeUserFavoriteProducts(uid: authDataResult.uid,
                                                          favoriteProductId: favoriteProductId)
            
            getAllFavorites()
        }
    }
}

struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu(ContextMenu(menuItems: {
                        Button(action: {
                            viewModel.removeFromFavorites(favoriteProductId: item.id)
                        }, label: {
                            Text("Remove from favorites")
                        })
                    }))
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.getAllFavorites()
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
