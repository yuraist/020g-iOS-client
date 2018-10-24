//
//  Product.swift
//  020g
//
//  Created by Юрий Истомин on 27/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//
// * I'm sorry for properties that are called "aviable", but it's not my mistake.
// The name I get from API, so it's more clearly and comfortably to use this name here.

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
  
  static func getProducts(fromJsonArray array: [Dictionary<String, Any>]) -> [Product] {
    var products = [Product]()
    for productDictionary in array {
      let product = Product(withDictionary: productDictionary)
      products.append(product)
    }
    return products
  }
}

struct Products: Codable {
  let list: [Product]
  
  enum CodingKeys: String, CodingKey {
    case list = "list"
  }
}

struct ProductFull: Codable {
  var id: Int
  var costs: String
  var cost: String
  var name: String
  var desc: String
  var images: [String]
  var opts: [Option]
  var prices: [Price]
}

struct Option: Codable {
  var name: String
  var fil: String?
  var value: String
}

struct Price: Codable {
  var id: Int
  var site: String
  var aviable: Int
  var capt: String
  var city: String
  var price: String
  
  var isAvailable: Bool {
    return aviable == 1
  }
}

struct Breadcrumb: Codable {
  var id: Int
  var name: String
}

struct City: Codable {
  var name: String
  var count: Int
  var selected: Bool
  var aviable: Bool
}

struct ProductResponse: Codable {
  var status: Bool
  var product: ProductFull
  var breadcrumbs: [Breadcrumb]
  var cities: [City]
}

struct CatalogResponse: Codable {
  var status: Bool
  var list: [Product]
  var params: [String: String]
}
