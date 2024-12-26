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
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil

//    func getAllProducts() async throws {
//        self.products = try await ProductsManager.shared.getAllProducts()
//    }
    
    enum FilterOption: String, CaseIterable {
        case none
        case priceHigh
        case priceLow
        
        var priceDecending: Bool? {
            switch self {
            case .none:
                return nil
            case .priceLow:
                return false
            case .priceHigh:
                return true
            }
        }
    }
    
    func filterSelected(option: FilterOption) {
        self.selectedFilter = option
        getProducts()
    }
    
    enum CategoryOption: String, CaseIterable {
        case smartphone
        case laptop
        case fragrances
        case none
        
        var categoryKey: String? {
            if self == .none {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) {
        self.selectedCategory = option
        getProducts()
    }
    
    func getProducts() {
        Task {
            self.products = try await ProductsManager.shared.getAllProductsByPrice(priceDescending: selectedFilter?.priceDecending, forCategory: selectedCategory?.categoryKey)
        }
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
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            viewModel.filterSelected(option: option)
                            
                        }
                    }
                    
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { option in
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
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
