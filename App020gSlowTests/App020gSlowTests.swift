//
//  App020gSlowTests.swift
//  App020gSlowTests
//
//  Created by Юрий Истомин on 12/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import XCTest
@testable import App020g

class App020gSlowTests: XCTestCase {
  
  var apiHandler: ApiHandler!
  
  override func setUp() {
    super.setUp()
    apiHandler = ApiHandler.shared
  }
  
  override func tearDown() {
    apiHandler = nil
    super.tearDown()
  }
  
  func testFetchApiKeys() {
    // given
    let promise = expectation(description: "Completion handler invoked")
    var token: String?
    
    // when
    apiHandler.checkKeys { (success) in
      if success {
        token = ApiKeys.token
      }
      promise.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    // then
    XCTAssertNotNil(token)
  }
  
  func testProductImageSize() {
    let promise = expectation(description: "Completion handler invoked")
    apiHandler.fetchProducts(ofCategory: 0, page: 1) { (success, products) in
      if let products = products {
        for product in products {
          XCTAssertTrue(product.img.hasPrefix("http://020g.ru/ipk/g1"))
        }
      }
      promise.fulfill()
    }
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testChangeProductImageSize() {
    
  }
  
}
