//
//  ProductsView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 24/12/24.
//

import SwiftUI

struct ProductsView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
               ProductCellView(product: product)
                    .contextMenu(ContextMenu(menuItems: {
                        Button(action: {
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        }, label: {
                            Text("Add to favorites")
                        })
                    }))
                
                if product == viewModel.products.last && viewModel.products.count < viewModel.allProductsCount {
                    ProgressView()
                        .onAppear {
                            viewModel.getProducts()
                        }
                }
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.FilterOption.allCases, 
                            id: \.self) { option in
                        Button(option.rawValue) {
                            viewModel.filterSelected(option: option)
                            
                        }
                    }
                    
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases, 
                            id: \.self) { option in
                        Button(option.rawValue) {
                            viewModel.categorySelected(option: option)
                            
                        }
                    }
                    
                }
            }
        })
        .onAppear {
//            viewModel.downloadProductsAndUploadToFirebase()
            viewModel.getProducts()
            viewModel.getAllProductsCount()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
