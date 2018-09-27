//
//  APIManager.swift
//  020g
//
//  Created by Юрий Истомин on 26/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

enum Method: String {
  case get = "GET"
  case post = "POST"
}

extension URLRequest {
  static func configureRequest(forPath path: String, queryItems items: [URLQueryItem], method: Method) -> URLRequest {
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = "020g.ru"
    urlComponents.path = path
    urlComponents.queryItems = items
    
    guard let url = urlComponents.url else {
      fatalError("cannot create a url")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return request
  }
}

/// An intergace to manage API requests
class APIManager {
  
  static let shared = APIManager()
  
  let urlScheme = "http"
  let baseUrl = "020g.ru"
  let appName = "020g"
  
  
  /// Requests a catalog_key and super_key to API and returns the success block.
  /**
   Configuers an HTTP-request by creating URL from the url components
   (scheme, host, path) and query items (parameters)
   - parameters:
     - success: Contains true value if a new token (catalog_key) has been received else contains false
   */
  func checkKeys(success: ((Bool)->Void)?) {
    // Configure url
    var urlComponents = URLComponents()
    urlComponents.scheme = urlScheme
    urlComponents.host = baseUrl
    urlComponents.path = "/abpro/check_keys"
    
    // Get catalog_key if there is one
    let catalogKey = UserDefaults.standard.string(forKey: "token")
    
    // Add query parameters
    let catalogKeyItem = URLQueryItem(name: "catalog_key", value: catalogKey ?? "")
    let superKeyItem = URLQueryItem(name: "super_key", value: "")
    
    urlComponents.queryItems = [catalogKeyItem, superKeyItem]
    
    // Create url from the url components
    guard let url = urlComponents.url else {
      fatalError("Could not create URL from components")
    }
    
    // Configure an http request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // Configure a url session
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    // Create a data task
    let task = session.dataTask(with: request) { (data, response, error) in
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
  func guestIndex(token: String, completion: ((Bool, [Category]?)->Void)?) {
    // Configure url components
    var urlComponents = URLComponents()
    urlComponents.scheme = urlScheme
    urlComponents.host = baseUrl
    urlComponents.path = "/abpro/guest_index"
    
    let tokenItem = URLQueryItem(name: "token", value: ApiKeys.token!)
    let appNameItem = URLQueryItem(name: "appname", value: appName)
    
    urlComponents.queryItems = [tokenItem, appNameItem]
    
    // Configure url
    guard let url = urlComponents.url else {
      fatalError("Could not create URL from components")
    }
    
    // Create a request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    // Create a task
    let task = session.dataTask(with: request) { (data, response, error) in
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
    
    task.resume()
  }
  
  func getTabProducts(categoryId: Int, page: Int, completion: ((Bool, [Product]?)->Void)?) {
    // Check the identification token
    guard let token = ApiKeys.token else {
      fatalError("No token")
    }

    // Create query items for a request
    let tokenItem = URLQueryItem(name: "token", value: token)
    let appnameItem = URLQueryItem(name: "appname", value: appName)
    let categoryItem = URLQueryItem(name: "cat", value: "\(categoryId)")
    let pageItem = URLQueryItem(name: "page", value: "\(page)")
    let queryItems = [tokenItem, appnameItem, categoryItem, pageItem]
    
    // Configure the request
    let request = URLRequest.configureRequest(forPath: "/abpro/get_tab_products", queryItems: queryItems, method: .get)
    // Configure a session
    let session = URLSession(configuration: .default)
    // Configure a task
    let dataTask = session.dataTask(with: request) { (data, response, error) in
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
