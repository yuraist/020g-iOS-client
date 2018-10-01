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

/// An intergace to manage API requests
class ApiHandler {
  
  static let shared = ApiHandler()

  let appName = "020g"
  
  /// Requests a catalog_key and super_key to API and returns the success block.
  /**
   Configuers an HTTP-request by creating URL from the url components
   (scheme, host, path) and query items (parameters)
   - parameters:
   - success: Contains true value if a new token (catalog_key) has been received else contains false
   */
  func checkKeys(success: ((Bool)->Void)?) {
    // Create a data task
    var queryItems = ["super_key": ""]
    if let catalogKey = UserDefaults.standard.string(forKey: "token") {
      queryItems["catalog_key"] = catalogKey
    } else {
      queryItems["catalog_key"] = ""
    }
    
    let task = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/check_keys", queryItems: queryItems, method: .get) { (data, response, error) in
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
    
    // Start the task
    task.resume()
  }
  
  /// Returns a block with boolean value of request success and with an array of received categories
  /**
   Creates a request that configured the same way as checkKeys(success:) to the API
   - parameters:
   - token: String to pass into HTTP-request parameters
   - completion: Completion handler to call when the request is complete.
   */
  func fetchCatalogCategories(token: String, completion: ((Bool, [Category]?)->Void)?) {
    guard let token = ApiKeys.token else {
      // Cannot complete the request
      completion?(false, nil)
      return
    }
    
    // Check a token and get categories if there is the token
    let queryItems = ["token": token, "appname": appName]
    let task = URLSessionDataTask.getDefaultDataTask(forPath: "/abpro/guest_index", queryItems: queryItems, method: .get) { (data, response, error) in
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
    
    // Resume the task
    task.resume()
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
    // Check the identification token
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
    
    // Resume the data task
    dataTask.resume()
  }
}
