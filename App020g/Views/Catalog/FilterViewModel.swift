//
//  FilterViewModel.swift
//  App020g
//
//  Created by Юрий Истомин on 14/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

class FilterViewModel {
  
  var filterResponse: FilterResponse
  
  var selectedCost: (min: Int, max: Int)? {
    didSet {
      updateFilterCount()
    }
  }
  
  var selectedParameters: [Int: [Int]] {
    didSet {
      updateFilterCount()
    }
  }
  
  var filterCount: Observable<Int>
  var sortingType: SortingType
  
  var filterRequest: FilterRequest {
    get {
      return FilterRequest(category: "\(categoryId)",
      page: "1",
      cost: selectedCost,
      options: selectedParameters,
      sort: sortingType.rawValue)
    }
  }
  
  private var categoryId: Int
  
  init(filterResponse: FilterResponse, categoryId: Int, sortingType: SortingType, filterRequest: FilterRequest) {
    self.filterResponse = filterResponse
    self.categoryId = categoryId
    self.selectedParameters = filterRequest.options ?? [:]
    self.filterCount = Observable(0)
    self.sortingType = sortingType
  }
  
}

extension FilterViewModel {
  func updateFilter(completion: @escaping ()->Void) {
    ServerManager.shared.fetchFilter(forCategoryId: categoryId) { [unowned self] (response) in
      if response != nil {
        self.filterResponse = response!
      }
      completion()
    }
  }
}

extension FilterViewModel {
  private func updateFilterCount() {
    ServerManager.shared.getFilterCount(filter: filterRequest) { [unowned self] (count) in
      self.filterCount.value = count
    }
  }
}
