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
  
  var breadcrumbs = [Breadcrumb]()
  var categories = [SearchCategory]()
  var products = [SearchProduct]()
  
  private var currentPage = 0
  var selectedCategory: SearchCategory? = .none
}

extension SearchViewModel {
  
  func search(query: String, completion: @escaping () -> Void) {
    serverManager.search(query: query, page: currentPage, category: selectedCategory?.id) { [unowned self] (response) in
      if let searchResponse = response {
        self.products = searchResponse.list
        self.categories = searchResponse.cats
        self.breadcrumbs = searchResponse.breadcrumbs
      }
      completion()
    }
  }
  
  func incrementPage() {
    currentPage += 1
  }
}
