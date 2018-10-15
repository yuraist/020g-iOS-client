//
//  BarButton.swift
//  020g
//
//  Created by Юрий Истомин on 01/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class BarButton: UIButton {
  
  init(image: UIImage) {
    super.init(frame: .zero)
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    setTintColorWhite()
    setNormalImage(image)
  }
  
  private func setTintColorWhite() {
    tintColor = ApplicationColors.white
  }
  
  private func setNormalImage(_ image: UIImage) {
    setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
