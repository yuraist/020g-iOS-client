//
//  ShopsViewModel.swift
//  App020g
//
//  Created by Юрий Истомин on 05/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

class ShopsViewModel {
  
  private let apiHandler: ApiHandler
  
  var shops: [Shop] = []
  
  init(handler: ApiHandler) {
    self.apiHandler = handler
  }
  
  func fetch(completion: @escaping () -> Void) {
    apiHandler.fetchShops { [weak self] (success, shops) in
      self?.shops = shops ?? []
      completion()
    }
  }
}
