//
//  FilterParameterNameLabel.swift
//  App020g
//
//  Created by Юрий Истомин on 31/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class FilterParameterNameLabel: UILabel {
  
  init(text: String, isMainTitle: Bool) {
    super.init(frame: .zero)
    
    setupLabel(withText: text)
    setFont(forMainTitle: isMainTitle)
  }
  
  private func setupLabel(withText text: String) {
    self.text = text
    textColor = ApplicationColors.buttonBlue
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
  }
  
  private func setFont(forMainTitle: Bool) {
    font = forMainTitle ? UIFont.systemFont(ofSize: 17) : UIFont.systemFont(ofSize: 14, weight: .light)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
