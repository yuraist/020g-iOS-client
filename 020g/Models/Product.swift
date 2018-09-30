//
//  Product.swift
//  020g
//
//  Created by Юрий Истомин on 27/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

struct Product: Codable {
  let id: Int
  let name: String
  let brand: String
  let priceMin: Int
  let priceMax: Int
  let bind: Int
  let img: String
  let active: Bool
  let available: Bool
  let like: Bool
  let mark: Bool
  
  enum CodingKeys: String, CodingKey {
    case id, name, brand, bind, img, active, like, mark
    case priceMin = "c_min"
    case priceMax = "c_max"
    case available = "aviable"
  }
  
  init(withDictionary dictionary: [String: Any]) {
    id = Int((dictionary["id"] as! NSString).intValue)
    name = dictionary["name"] as! String
    brand = dictionary["brand"] as! String
    priceMin = Int((dictionary["c_min"] as! NSString).intValue)
    priceMax = Int((dictionary["c_max"] as! NSString).intValue)
    bind = Int((dictionary["bind"] as! NSString).intValue)
    img = dictionary["img"] as! String
    active = Bool((dictionary["id"] as! NSString).boolValue)
    available = Bool((dictionary["aviable"] as! NSString).boolValue)
    like = Bool((dictionary["id"] as! NSString).boolValue)
    mark = Bool((dictionary["id"] as! NSString).boolValue)
  }
}

struct Products: Codable {
  let list: [Product]
  
  enum CodingKeys: String, CodingKey {
    case list = "list"
  }
}
