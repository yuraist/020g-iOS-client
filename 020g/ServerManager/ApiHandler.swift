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

class ApiHandler {
  
  static let shared = ApiHandler()
  
  let appName = "020g"
  
 
  func checkKeys(success: ((Bool)->Void)?) {
    
    var queryItems = ["super_key": ""]
    if let catalogKey = UserDefaults.standard.string(forKey: "token") {
      queryItems["catalog_key"] = catalogKey
    } else {
      queryItems["catalog_key"] = ""
    }
    
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/check_keys", queryItems: queryItems, method: .get) { (data, response, error) in
      if let error = error {
        print(error)
      } else if let jsonData = data {
        let decoder = JSONDecoder()
        do {
          let keys = try decoder.decode(ApiKeys.self, from: jsonData)
          ApiKeys.token = keys.catalogKey
          success?(true)
        } catch {
          success?(false)
        }
      } else {
        success?(false)
      }
    }
    dataTask.resume()
  }
  
  /// Returns a block with boolean value of request success and with an array of received categories
  /**
   Creates a request that configured the same way as checkKeys(success:) to the API
   - parameters:
   - token: String to pass into HTTP-request parameters
   - completion: Completion handler to call when the request is complete.
   */
  func fetchCatalogCategories(completion: ((Bool, [Category]?)->Void)?) {
    guard let token = ApiKeys.token else {
      // Cannot complete the request
      completion?(false, nil)
      return
    }
    
    // Check a token and get categories if there is the token
    let queryItems = ["token": token, "appname": appName]
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/guest_index", queryItems: queryItems, method: .get) { (data, response, error) in
      if let error = error {
        print(error)
      } else if let jsonData = data {
        let decoder = JSONDecoder()
        
        do {
          let categories = try decoder.decode(Categories.self, from: jsonData)
          let categoriesArray = categories.list
          completion?(true, categoriesArray)
        } catch {
          completion?(false, nil)
        }
      } else {
        completion?(false, nil)
      }
    }
    dataTask.resume()
  }
  
  /// Fetches a product list for the specific category
  /**
   Checks the auth token and requests products if the token is passed.
   - parameters:
   - categoryId: integer value of the category for which you want to fetch products
   - page: integer value of page of product list pagination
   - completion: block that constains the boolean value of request success and the Product array
   */
  func fetchProducts(ofCategory categoryId: Int, page: Int, completion: ((Bool, [Product]?)->Void)?) {
    guard let token = ApiKeys.token else {
      completion?(false, nil)
      return
    }
    
    let queryItems = ["token": token, "appname": appName, "cat": "\(categoryId)", "page": "\(page)"]
    let dataTask = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/get_tab_products", queryItems: queryItems, method: .get) { (data, response, error) in
      if error != nil {
        print(error!)
        completion?(false, nil)
      }
      
      if let jsonData = data {
        do {
          let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
          let productDictionaryList = jsonObject["list"] as! [Dictionary<String, Any>]
          
          var products = [Product]()
          for productDict in productDictionaryList {
            let product = Product(withDictionary: productDict)
            products.append(product)
          }
          completion?(true, products)
        } catch {
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
      if error != nil {
        completion?(false, nil)
        return
      }
      
      if let jsonData = data {
        do {
          let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
          if let jsonShops = jsonObject["list"] as? [[String: Any]] {
            var shops = [Shop]()
            for jsonShop in jsonShops {
              shops.append(Shop(withDictionary: jsonShop))
            }
            completion?(true, shops)
          }
          completion?(false, nil)
        } catch {
          completion?(false, nil)
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
}
