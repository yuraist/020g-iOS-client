//
//  CatalogCategory.swift
//  App020g
//
//  Created by Юрий Истомин on 17/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

struct CatalogCategory: Codable {
  var news: String
  var categoryId: String
  var categoryName: String
  
  enum CodingKeys: String, CodingKey {
    case news
    case categoryId = "cat_id"
    case categoryName = "cat_name"
  }
}

struct CatalogCategories: Codable {
  var categories: [CatalogCategory]
  
  enum CodingKeys: String, CodingKey {
    case categories = "list"
  }
}
