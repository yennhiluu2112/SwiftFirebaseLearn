//
//  ProductCellView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 24/12/24.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: Color.black.opacity(0.3), radius: 4 ,x: 0, y: 2)

            VStack(alignment: .leading) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Price: $ \(product.price ?? 0)")
                Text("Rating: \(product.rating ?? 0)")
                Text("Category: \(product.category ?? "n/a")")
                Text("Brand: \(product.brand ?? "n/a")")
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ProductCellView(product: Product(id: -1, 
                                     title: "",
                                     description: "",
                                     price: 0, 
                                     discountPercentage: 0, 
                                     rating: 0,
                                     stock: 0, 
                                     brand: "",
                                     category: "",
                                     thumbnail: "",
                                     images: []))
}
