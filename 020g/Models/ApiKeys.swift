//
//  ApiKeys.swift
//  020g
//
//  Created by Юрий Истомин on 26/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

struct ApiKeys: Codable {
  
  static var token = UserDefaults.standard.string(forKey: "token")
  
  static func setToken(token: String) {
    saveTokenToUserDefaults(token: token)
    self.token = token
  }
  
  private static func saveTokenToUserDefaults(token: String) {
    UserDefaults.standard.set(token, forKey: "token")
  }
  
  var catalogKey: String
  var superKey: String?
  
  enum CodingKeys: String, CodingKey {
    case catalogKey = "catalog_key"
    case superKey = "super_key"
  }
}
