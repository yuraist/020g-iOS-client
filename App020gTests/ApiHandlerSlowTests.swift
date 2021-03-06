//
//  ApiHandlerSlowTests.swift
//  App020gTests
//
//  Created by Юрий Истомин on 17/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import XCTest
@testable import App020g

class ApiHandlerSlowTests: XCTestCase {
  
  func testFetchCatalogCategories() {
    // given
    let promise = expectation(description: "Get categories")
    let handler = ServerManager.shared
    var categoriesObject: CatalogCategories?
    
    // when
    handler.fetchCatalogTreeCategories { (success, categories) in
      if let categories = categories {
        promise.fulfill()
        categoriesObject = categories
      }
    }
    
    // then
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertNotNil(categoriesObject)
  }
  
  func testFetchCatalogTreeByCategories() {
    // given
    let promise = expectation(description: "Get subcategories")
    let handler = ServerManager.shared
    var catalogTree: CatalogTree?
    
    // when
    handler.fetchCatalogTree(byCategory: "5") { (success, tree) in
      if let tree = tree {
        promise.fulfill()
        catalogTree = tree
      }
    }
    
    // then
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertNotNil(catalogTree)
  }
  
  func testFetchFilter() {
    // given
    let promise = expectation(description: "")
    let categoryId = 143
    var filterResponse: FilterResponse?
    
    // when
    ServerManager.shared.fetchFilter(forCategoryId: categoryId) { (filter) in
      if let filter = filter {
        print(filter)
        filterResponse = filter
        promise.fulfill()
      }
    }
    
    // then
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertNotNil(filterResponse)
  }
  
  func testFetchCatalogReponse() {
    // given
    let promise = expectation(description: "")
//let options = [(1, 361), (1, 292), (21, 182)]
    let options = [1: [361, 292], 21: [182]]
    let filterRequest = FilterRequest(category: "143", page: "1", cost: (300, 1000), options: options, sort: nil)
    var catalogResponse: CatalogResponse?
    
    // when
    ServerManager.shared.fetchFilteredProducts(withFilter: filterRequest) { (catalog) in
      if let catalog = catalog {
        catalogResponse = catalog
        promise.fulfill()
      }
    }
    
    // then
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertNotNil(catalogResponse)
  }
  
  func testGetFilterCount() {
    // given
    let filterRequest = FilterRequest(category: "401",
                                      page: "1",
                                      cost: nil,
                                      options: Optional([21: [244], 1: [4]]),
                                      sort: nil)
    
    let promise = expectation(description: "")
    var filterCount = 0
    
    // when
    ServerManager.shared.getFilterCount(filter: filterRequest) { count in
      filterCount = count
      print(count)
      promise.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertNotEqual(filterCount, 0)
  }
  
  func testSearch() {
    // given
    let promise = expectation(description: "")
    var searchResponse: SearchResponse? = .none
    
    // when
    ServerManager.shared.search(query: "авто", page: nil, category: nil) { (response) in
      searchResponse = response
//      print(searchResponse)
      promise.fulfill()
    }
    
    // then
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertNotNil(searchResponse)
  }
}
