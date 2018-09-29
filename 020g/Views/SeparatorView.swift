//
//  SeparatorView.swift
//  020g
//
//  Created by Юрий Истомин on 19/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SeparatorView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = ApplicationColors.lightGray
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
