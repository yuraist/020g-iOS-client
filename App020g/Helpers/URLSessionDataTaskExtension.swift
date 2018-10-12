//
//  URLSessionDataTaskExtension.swift
//  020g
//
//  Created by Юрий Истомин on 29/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

extension URLSessionDataTask {
  static func getDefaultDataTask(forPath path: String,
                                 queryItems itemsDictionary: [String: String],
                                 method: HTTPMethod,
                                 completionHandler completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    
    let request = URLRequest.getRequest(forPath: path, queryItems: itemsDictionary, method: method)
    let dataTask = URLSession(configuration: .default).dataTask(with: request, completionHandler: completion)
    return dataTask
  }
}

extension URLRequest {
  
  static func getRequest(forPath path: String, queryItems itemsDictionary: [String: String], method: HTTPMethod) -> URLRequest {
    // Configure a URL
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = "020g.ru"
    urlComponents.path = path
    
    var items = [URLQueryItem]()
    for (name, value) in itemsDictionary {
      items.append(URLQueryItem(name: name, value: value))
    }
    urlComponents.queryItems = items
    
    guard let url = urlComponents.url else {
      fatalError("cannot create a url")
    }
    
    // Configure a request
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return request
  }
}
