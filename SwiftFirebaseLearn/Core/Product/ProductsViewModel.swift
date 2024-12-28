//
//  ProductsViewModel.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 28/12/24.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ProductsViewModel: ObservableObject {
    
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
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    @Published var allProductsCount: Int = 0
    private var lastDocument: DocumentSnapshot? = nil
    
    func filterSelected(option: FilterOption) {
        self.selectedFilter = option
        self.products = []
        self.lastDocument = nil
        getProducts()
    }
    
    func categorySelected(option: CategoryOption) {
        self.selectedCategory = option
        self.products = []
        self.lastDocument = nil
        getProducts()
    }
    
    func getProducts() {
        let price = selectedFilter?.priceDecending
        let category = selectedCategory?.categoryKey
        let limit = 10
        Task {
            let (newProducts, lastDoc) = try await ProductsManager
                .shared
                .getProducts(priceDescending: price,
                             forCategory: category,
                             count: limit,
                             lastDocument: lastDocument)
            if let lastDoc {
                self.lastDocument = lastDoc
            }
            self.products.append(contentsOf: newProducts)
        }
    }
    
    func getAllProductsCount() {
        Task {
            self.allProductsCount = try await ProductsManager
                .shared
                .getAllProductsCount()
        }
    }
}
