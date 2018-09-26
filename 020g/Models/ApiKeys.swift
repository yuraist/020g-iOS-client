//
//  ApiKeys.swift
//  020g
//
//  Created by Юрий Истомин on 26/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

struct ApiKeys: Codable {
  
  static var token: String? {
    didSet {
      if token != nil {
        UserDefaults.standard.set(token!, forKey: "token")
      }
    }
  }
  
  var catalogKey: String
  var superKey: String?
  
  enum CodingKeys: String, CodingKey {
    case catalogKey = "catalog_key"
    case superKey = "super_key"
  }
}
