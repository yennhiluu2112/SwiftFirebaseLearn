//
//  ProductCellViewBuilder.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 29/12/24.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    
    @State private var product: Product? = nil
    let productId: String
    
    var body: some View {
        ZStack {
            if let product {
                ProductCellView(product: product)
            }
        }
        .onAppear {
            Task {
                self.product = try await ProductsManager.shared.getProduct(id: productId)
            }
        }
    }
}

#Preview {
    ProductCellViewBuilder(productId: "1")
}
