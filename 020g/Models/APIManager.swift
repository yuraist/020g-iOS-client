//
//  APIManager.swift
//  020g
//
//  Created by Юрий Истомин on 26/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class APIManager {
  static let shared = APIManager()
  
  let baseUrl = "020g.ru"
  
  func checkKeys(withCatalogKey catalogKey: String?, completion: ((Bool, ApiKeys?)->Void)?) {
    // Configure url
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = "020g.ru"
    urlComponents.path = "/abpro/check_keys"
    
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
          completion?(true, keys)
        } catch {
          completion?(false, nil)
        }
      } else {
        completion?(false, nil)
      }
    }
    
    // Start the task
    task.resume()
  }
}
