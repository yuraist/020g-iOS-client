//
//  APIManager.swift
//  020g
//
//  Created by Юрий Истомин on 26/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

class ServerManager {
  
  let appName = "020g"
  static let shared = ServerManager()
  
  
  func checkKeys(success: ((Bool)->Void)?) {
    
    let queryItems = getCheckApiKeysQueryItems()
    
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/check_keys", queryItems: queryItems, method: .get) { (data, response, error) in
      
      if let jsonData = data {
        
        do {
          let keys = try self.decodeObject(ApiKeys.self, from: jsonData)
          ApiKeys.setToken(token: keys.catalogKey)
          success?(true)
        } catch let error {
          print(error)
          success?(false)
        }
        
      } else {
        success?(false)
      }
    }
    dataTask.resume()
  }
  
  private func getCheckApiKeysQueryItems() -> [String: String] {
    let catalogKey = getCurrentCatalogKey()
    let queryItems = ["super_key": "", "catalog_key": catalogKey]
    return queryItems
  }
  
  private func getCurrentCatalogKey() -> String {
    if let catalogKey = UserDefaults.standard.string(forKey: "token") {
      return catalogKey
    }
    return ""
  }
  
  private func decodeObject<T>(_ type: T.Type, from data: Data) throws -> T where T:Decodable {
    return try JSONDecoder().decode(T.self, from: data)
  }
  
  
  func fetchCatalogCategories(completion: ((Bool, [Category]?)->Void)?) {
    
    guard let token = ApiKeys.token else {
      completion?(false, nil)
      return
    }
    
    let queryItems = ["token": token, "appname": appName]
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/guest_index", queryItems: queryItems, method: .get) { (data, response, error) in
      if let jsonData = data {
        do {
          let categories = try self.decodeObject(Categories.self, from: jsonData)
          let categoriesArray = categories.list
          completion?(true, categoriesArray)
        } catch let error {
          print(error)
          completion?(false, nil)
        }
      } else {
        completion?(false, nil)
      }
    }
    dataTask.resume()
  }
  
  
  func fetchProducts(ofCategory categoryId: Int, page: Int, completion: ((Bool, [Product]?)->Void)?) {
    
    guard let token = ApiKeys.token else {
      completion?(false, nil)
      return
    }
    
    let queryItems = ["token": token, "appname": appName, "cat": "\(categoryId)", "page": "\(page)"]
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/get_tab_products", queryItems: queryItems, method: .get) { (data, response, error) in
      if let jsonData = data {
        do {
          let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
          
          let productsJsonArray = jsonObject["list"] as! [Dictionary<String, Any>]
          let products = Product.getProducts(fromJsonArray: productsJsonArray)
          
          completion?(true, products)
        } catch let error {
          print(error)
          completion?(false, nil)
        }
      } else {
        completion?(false, nil)
      }
    }
    dataTask.resume()
  }
  
  
  func fetchShops(completion: ((Bool, [Shop]?)->Void)?) {
    
    guard let token = ApiKeys.token else {
      completion?(false, nil)
      return
    }
    
    let queryItems = ["token": token]
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/get-shops", queryItems: queryItems, method: .get) { (data, response, error) in
      
      if let jsonData = data {
        do {
          let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
          if let jsonShops = jsonObject["list"] as? [[String: Any]] {
            var shops = [Shop]()
            for jsonShop in jsonShops {
              shops.append(Shop(withDictionary: jsonShop))
            }
            completion?(true, shops)
            return
          }
          completion?(false, nil)
          return
        } catch {
          completion?(false, nil)
          return
        }
      }
    }
    dataTask.resume()
  }
  
  func getUserInfo(completion: ((Bool, User?) -> Void)?) {
    guard let token = ApiKeys.token else {
      completion?(false, nil)
      return
    }
    
    let queryItems = ["key": token]
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/user/get", queryItems: queryItems, method: .get) { (data, response, err) in
      if let jsonData = data {
        let decoder = JSONDecoder()
        
        do {
          let users = try decoder.decode(Users.self, from: jsonData)
          completion?(true, users.user)
        } catch {
          completion?(false, nil)
        }
      }
    }
    dataTask.resume()
  }
  
  func authorize(login: Bool, data: [String: String], completion: ((Bool) -> Void)?) {
    var path = "/abpro/"
    
    if login {
      path.append("auth")
    } else {
      path.append("register")
    }
    
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: path, queryItems: data, method: .get) { (data, response, error) in
      guard let data = data else {
        completion?(false)
        return
      }
      
      do {
        let jsonObject = try self.getJsonObject(with: data)
        if let status = jsonObject["status"] as? Bool {
          completion?(status)
        }
      } catch {
        completion?(false)
      }
    }
    dataTask.resume()
  }  
  
  private func getJsonObject(with data: Data) throws -> [String: Any] {
    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
    return jsonObject as! [String: Any]
  }
  
  func restorePassword(data: [String: String], completion: (() -> Void)?) {
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/password", queryItems: data, method: .get) {_,_,_ in
      completion?()
    }
    dataTask.resume()
  }
  
  func askQuestion(data: [String: String], completion: (() -> Void)?) {
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/request", queryItems: data, method: .post) { (data, response, error) in
      if let data = data {
        do {
          let responseInfo = try JSONSerialization.jsonObject(with: data, options: [])
          print(responseInfo)
        } catch let error {
          print(error)
        }
      }
      completion?()
    }
    dataTask.resume()
  }
  
  func getProduct(withId id: Int, completion: ((Bool, ProductResponse?) -> Void)?) {
    guard let token = ApiKeys.token else {
      completion?(false, nil)
      return
    }
    
    let queryItems = ["token": token, "product": "\(id)", "appname": "020g"]
    
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/product", queryItems: queryItems, method: .get) { (data, response, error) in
      if let jsonData = data {
        let decoder = JSONDecoder()
        do {
          let productResponse = try decoder.decode(ProductResponse.self, from: jsonData)
          completion?(true, productResponse)
        } catch let error {
          print(error)
          completion?(false, nil)
        }
      }
    }
    dataTask.resume()
  }
  
  func fetchCatalogTreeCategories(completion: ((Bool, CatalogCategories?) -> Void)?) {
    guard let token = ApiKeys.token else {
      completion?(false, nil)
      return
    }
    
    let queryItems = ["token": token, "cat": "0", "appname": appName]
    
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/cat_catalog/", queryItems: queryItems, method: .get) { (data, _, _) in
      if let jsonData = data {
        do {
          let categories = try self.decodeObject(CatalogCategories.self, from: jsonData)
          completion?(true, categories)
        } catch let err {
          print(err)
          completion?(false, nil)
        }
      } else {
        completion?(false, nil)
      }
    }
    
    dataTask.resume()
  }
  
  func fetchCatalogTree(byCategory cat: String, completion: ((Bool, CatalogTree?) -> Void)?) {
    guard let token = ApiKeys.token else {
      completion?(false, nil)
      return
    }
    
    let queryItems = ["token": token, "cat": "\(cat)", "appname": appName]
    
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/get_tree_by_catalog", queryItems: queryItems, method: .get) { (data, _, _) in
      if let jsonData = data {
        do {
        let tree = try self.decodeObject(CatalogTree.self, from: jsonData)
        completion?(true, tree)
        } catch let error {
          print(error)
          completion?(false, nil)
        }
      } else {
        completion?(false, nil)
      }
    }
    
    dataTask.resume()
  }
  
  func fetchFilter(forCategoryId categoryId: Int, completion: ((FilterResponse?) -> Void)?) {
    guard let token = ApiKeys.token else {
      completion?(nil)
      return
    }
    
    let queryItems = ["token": token, "appname": appName, "cat": "\(categoryId)"]
    
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/get_filter", queryItems: queryItems, method: .get) { (data, _, _) in
      if let jsonData = data {
        do {
          let filterResponse = try self.decodeObject(FilterResponse.self, from: jsonData)
          completion?(filterResponse)
        } catch let error {
          print(error)
          completion?(nil)
        }
      }
      completion?(nil)
    }
    
    dataTask.resume()
  }
  
  func fetchFilteredProducts(withFilter filter: FilterRequest, completion: ((CatalogResponse?) -> Void)?) {
    guard let token = ApiKeys.token else {
      completion?(nil)
      return
    }
    
    var queryItems = ["token": token, "appname": appName, "cat": filter.category, "page": filter.page]
    
    if let cost = filter.cost {
      queryItems["cost"] = "\(cost.min)-\(cost.max)"
    }
    
    if let sort = filter.sort {
      queryItems["sort"] = sort
    }
    
    if let options = filter.options {
      var optionString = ""
      for (optionId, optionValues) in options {
        optionString += "_"
        for value in optionValues {
          optionString += "\(optionId)-\(value)."
        }
        optionString.removeLast()
        optionString += "_."
      }
      queryItems["o"] = optionString
    }
    
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/cat_prods_catalog", queryItems: queryItems, method: .get) { (data, _, _) in
      if let jsonData = data {
        do {
          let catalogResponse = try self.decodeObject(CatalogResponse.self, from: jsonData)
          completion?(catalogResponse)
        } catch let error {
          print(error)
          completion?(nil)
        }
      } else {
        completion?(nil)
      }
    }
    
    dataTask.resume()
  }
  
  func getFilterCount(filter: FilterRequest, completion: ((Int)->Void)?) {
    guard let token = ApiKeys.token else {
      completion?(0)
      return
    }
    
    var queryItems = ["token": token, "appname": appName, "cat": filter.category]
    
    if let minCost = filter.cost?.min, let maxCost = filter.cost?.max {
      queryItems["min_cost"] = String(minCost)
      queryItems["max_cost"] = String(maxCost)
    }
    
    if let options = filter.options {
      var optionString = ""
      for (optionId, optionValues) in options {
        optionString += "_"
        for value in optionValues {
          optionString += "\(optionId)-\(value)."
        }
        optionString.removeLast()
        optionString += "_."
      }
      queryItems["o"] = optionString
    }
    
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/get_filter_count", queryItems: queryItems, method: .get) { (data, _, _) in
      if let jsonData = data {
        do {
          let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
          
          if let count = jsonObject["count"] as? Int {
            completion?(count)
            return
          } else {
            completion?(0)
          }
        } catch let error {
          print(error)
          completion?(0)
        }
      }
    }
    
    dataTask.resume()
  }
  
  func search(query: String, page: Int?, category: Int?, completion: ((SearchResponse?) -> Void)?) {
    guard let token = ApiKeys.token else {
      completion?(nil)
      return
    }
    
    var queryItems = ["token": token, "query": query]
    
    if let category = category {
      queryItems["cat"] = String(category)
    }
    
    if let page = page {
      queryItems["page"] = String(page)
    }
    
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/search", queryItems: queryItems, method: .get) { (data, _, _) in
      if let jsonData = data {
        do {
          let searchResponse = try self.decodeObject(SearchResponse.self, from: jsonData)
          completion?(searchResponse)
          return
        } catch let error {
          completion?(nil)
          print(error)
          return
        }
      } else {
        completion?(nil)
        return
      }
    }
    
    dataTask.resume()
  }
}
