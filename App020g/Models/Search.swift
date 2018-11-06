//
//  Search.swift
//  App020g
//
//  Created by Юрий Истомин on 06/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
  var status: Bool
  var list: [SearchProduct]
  var cats: [SearchCategory]
  var breadcrumbs: [Breadcrumb]
}

struct SearchProduct: Codable {
  var id: String
  var name: String
  var url: String
  var c_max: String
  var c_min: String
  var mark: Int
  var like: String
  var type: String
  var tmp: String
  var own: String
  var aviable: String
  var brand: String
  var bind: String
  var img_med: String
  var img_small: String
}

struct SearchCategory: Codable {
  var id: Int
  var name: String
  var cnt: String
}

