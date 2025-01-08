//
//  FavoritesView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 29/12/24.
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var didAppear: Bool = false

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
        .onFirstAppear{
            viewModel.addListenerForFavorites()
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
