//
//  CatalogTree.swift
//  App020g
//
//  Created by Юрий Истомин on 17/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

struct CatalogTree: Codable {
  var status: Bool
  var list: [CatalogTreeSuperCategory]
  var tree: [CatalogTreeChildCategory]
}

struct CatalogTreeSuperCategory: Codable {
  var id: Int
  var name: String
  var count: Int
  var level: Int
  var parent: Int
  var news: Int
}

struct CatalogTreeChildCategory: Codable {
  var id: Int
  var name: String
  var count: Int
  var level: Int
  var news: Int
  var tree: [CatalogTreeChildCategory]?
  
  enum CodingKeys: String, CodingKey {
    case id = "i"
    case name = "n"
    case count = "c"
    case level = "l"
    case news
    case tree = "t"
  }
}
