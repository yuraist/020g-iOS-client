//
//  SearchViewModel.swift
//  App020g
//
//  Created by Юрий Истомин on 06/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

class SearchViewModel {
  
  private var serverManager = ServerManager()
  private var currentQuery = ""
  
  var breadcrumbs = [Breadcrumb]()
  var categories = [SearchCategory]()
  var products = [SearchProduct]()
  
  var noMorePages = false
  
  private var currentPage = 0
  var selectedCategory: SearchCategory? = .none
}

extension SearchViewModel {
  
  func search(query: String, completion: @escaping () -> Void) {
    currentQuery = query
    
    serverManager.search(query: currentQuery, page: currentPage, category: selectedCategory?.id) { [unowned self] (response) in
      if let searchResponse = response {
        self.products = searchResponse.list
        self.categories = searchResponse.cats
        self.breadcrumbs = searchResponse.breadcrumbs
      }
      completion()
    }
  }
  
  func fetchNextPage(completion: @escaping () -> Void) {
    incrementPage()
    
    serverManager.search(query: currentQuery, page: currentPage, category: selectedCategory?.id) { [unowned self] (response) in
      if let searchResponse = response {
        if searchResponse.list.count == 0 {
          self.noMorePages = true
        } else {
          self.products.append(contentsOf: searchResponse.list)
        }
      }
      completion()
    }
  }
  
  private func incrementPage() {
    currentPage += 1
  }
  
  func fetch(product: SearchProduct, completion: @escaping(ProductResponse?) -> Void) {
    serverManager.getProduct(withId: Int(product.id)!) { (_, response) in
      completion(response)
    }
  }
}
