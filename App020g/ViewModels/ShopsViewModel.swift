//
//  ShopsViewModel.swift
//  App020g
//
//  Created by Юрий Истомин on 05/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

class ShopsViewModel {
  
  private let serverManager: ServerManager
  
  var shops: [Shop] = []
  
  init(manager: ServerManager) {
    self.serverManager = manager
  }
  
}

// MARK :- Public methods

extension ShopsViewModel {
  func fetch(completion: @escaping () -> Void) {
    serverManager.fetchShops { [weak self] (success, shops) in
      self?.shops = shops ?? []
      completion()
    }
  }
}
