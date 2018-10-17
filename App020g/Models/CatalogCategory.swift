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
  var id: String
  var name: String
  var count: String
  
  enum CodingKeys: String, CodingKey {
    case news
    case id = "cat_id"
    case name = "cat_name"
    case count = "prod_cnt"
  }
}

struct CatalogCategories: Codable {
  var categories: [CatalogCategory]
  
  enum CodingKeys: String, CodingKey {
    case categories = "list"
  }
}
