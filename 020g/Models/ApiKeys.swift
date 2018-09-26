//
//  ApiKeys.swift
//  020g
//
//  Created by Юрий Истомин on 26/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

struct ApiKeys: Codable {
  var catalogKey: String
  var superKey: String?
  
  enum CodingKeys: String, CodingKey {
    case catalogKey = "catalog_key"
    case superKey = "super_key"
  }
}
