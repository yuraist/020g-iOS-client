//
//  CatalogViewModel.swift
//  App020g
//
//  Created by Юрий Истомин on 12/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

class CatalogViewModel {
  
  var filter: FilterRequest
  var sorting: SortingType = .chipFirst
  var products: Observable<[CodableProduct]>
  
  var numberOfProducts: Int {
    return products.value.count
  }
  
  init(_ filterRequest: FilterRequest) {
    filter = filterRequest
    products = Observable([CodableProduct]())
  }
  
}

extension CatalogViewModel {
  
  func fetchNewProducts() {
    ServerManager.shared.fetchFilteredProducts(withFilter: filter) { (response) in
      if response != nil {
        self.products.value = response!.list
      }
    }
  }
  
  func fetchNextPage() {
    incrementFilterPage()
    ServerManager.shared.fetchFilteredProducts(withFilter: filter) { (response) in
      if response != nil {
        self.products.value.append(contentsOf: response!.list)
      }
    }
  }
  
  private func incrementFilterPage() {
    if let currentPage = Int(filter.page) {
      filter.page = String(currentPage + 1)
    }
  }
  
  func fetch(selectedProduct product: CodableProduct, completion: @escaping (ProductResponse?) -> Void) {
    
    ServerManager.shared.getProduct(withId: Int(product.id)!) { (_, response) in
      completion(response)
    }
  }
  
  func getProduct(at indexPath: IndexPath) -> CodableProduct {
    let item = indexPath.item
    let product = products.value[item]
    return product
  }
}
