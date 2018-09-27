//
//  ApiKeys.swift
//  020g
//
//  Created by Юрий Истомин on 26/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

/// A keys stogare interface
struct ApiKeys: Codable {
  
  /// A string to pass into API requests as an identification key
  static var token = UserDefaults.standard.string(forKey: "token") {
    didSet {
      if token != nil {
        UserDefaults.standard.set(token!, forKey: "token")
      }
    }
  }
  
  /// A string that pass as a token string
  var catalogKey: String
  
  /// An unnecessary string to store, but it must be passed
  /// as a query parameter into the APIManager method to checking keys
  var superKey: String?
  
  enum CodingKeys: String, CodingKey {
    case catalogKey = "catalog_key"
    case superKey = "super_key"
  }
}
