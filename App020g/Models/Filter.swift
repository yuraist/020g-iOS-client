//
//  Filter.swift
//  App020g
//
//  Created by Юрий Истомин on 23/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

struct FilterResponse: Codable {
  var status: Bool
  var count: Int
  var list: [FilterParameter]
}

struct FilterParameter: Codable {
  var id: Int
  var name: String
  var type: Int
  var options: [FilterOption]?
  var cost_min_orig: String?
  var cost_max_orig: String?
  var cost_min: Int?
  var cost_max: Int?
}

struct FilterOption: Codable {
  var name: String
  var value: Int
  var count: Int
  var selected: Bool
}

struct FilterRequest {
  var category: Int
  var page: Int
  var cost: (min: Int, max: Int)?
  var options: [(id: Int, value: Int)]?
}
