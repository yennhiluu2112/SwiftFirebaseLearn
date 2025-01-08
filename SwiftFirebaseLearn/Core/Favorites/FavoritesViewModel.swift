//
//  FavoritesViewModel.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 8/1/25.
//

import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    private var cancellable = Set<AnyCancellable>()
    
    func addListenerForFavorites() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else { return }
        
        UserManager.shared.addListenerForAllUserFavoriteProducts(uid: authDataResult.uid).sink { completion in
            
        } receiveValue: { [unowned self] products in
            self.userFavoriteProducts = products
        }
        .store(in: &cancellable)

    }
    
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()

            try await UserManager.shared.removeUserFavoriteProducts(uid: authDataResult.uid,
                                                          favoriteProductId: favoriteProductId)
            
        }
    }
}
