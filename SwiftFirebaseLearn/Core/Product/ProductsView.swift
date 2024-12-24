//
//  ProductsView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 24/12/24.
//

import SwiftUI

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    
    func getAllProducts() async throws {
        self.products = try await ProductsManager.shared.getAllProducts()
    }
    
}

struct ProductsView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
               ProductCellView(product: product)
            }
        }
        .navigationTitle("Products")
        .task {
            try? await viewModel.getAllProducts()
        }
//        .onAppear {
//            viewModel.downloadProductsAndUploadToFirebase()
//        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
