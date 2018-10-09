//
//  CustomBarButtonItem.swift
//  020g
//
//  Created by Юрий Истомин on 01/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CustomBarButtonItem: UIBarButtonItem {
  
  override var customView: UIView? {
    didSet {
      setupConstraintsForCustomView()
    }
  }
  
  init(button: BarButton) {
    super.init()
    customView = button
  }
  
  private func setupConstraintsForCustomView() {
    customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
    customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
