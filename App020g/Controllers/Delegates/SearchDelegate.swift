//
//   SearchDelegate.swift
//  App020g
//
//  Created by Юрий Истомин on 27/11/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import Foundation

protocol SearchDelegate: class {
  func updateBreadcrumbs(withBreadcrumbId id: Int)
}
