//
//  SelectedCellLineView.swift
//  020g
//
//  Created by Юрий Истомин on 04/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SelectedCellLineView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = ApplicationColors.darkBlue
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
