//
//  App020gFakeTests.swift
//  App020gSlowTests
//
//  Created by Юрий Истомин on 12/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import XCTest
@testable import App020g

class App020gFakeTests: XCTestCase {
  var controllerUnderTest: MainCollectionViewController!
  
  override func setUp() {
    super.setUp()
    controllerUnderTest = MainCollectionViewController()
  }
  
  override func tearDown() {
    controllerUnderTest = nil
    super.tearDown()
  }
  
  func testFetchProducts() {
    XCTAssertEqual(controllerUnderTest.products.count, 0, "The products array should be empty before the products fetches")
    
  }
  
}
