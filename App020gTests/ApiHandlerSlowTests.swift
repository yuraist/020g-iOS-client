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
    let handler = ApiHandler.shared
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
    let handler = ApiHandler.shared
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
    ApiHandler.shared.fetchFilter(forCategoryId: categoryId) { (filter) in
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
  
  func testfetchCatalogReponse() {
    // given
    let promise = expectation(description: "")
    let options = [(1, 361), (1, 292), (21, 182)]
    let filterRequest = FilterRequest(category: "143", page: "1", cost: (300, 1000), options: options, sort: nil)
    var catalogResponse: CatalogResponse?
    
    // when
    ApiHandler.shared.fetchFilteredProducts(withFilter: filterRequest) { (catalog) in
      if let catalog = catalog {
        catalogResponse = catalog
        promise.fulfill()
      }
    }
    
    // then
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertNotNil(catalogResponse)
  }
}
