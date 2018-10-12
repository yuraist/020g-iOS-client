//
//  CustomHeaderView.swift
//  App020g
//
//  Created by Юрий Истомин on 12/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {
  
  var text: String? {
    didSet {
      label.text = text
    }
  }
  
  let label: UILabel = {
    let label = UILabel()
    label.textColor = ApplicationColors.darkGray
    label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addLabel()
    setupLabelConstraints()
  }
  
  private func addLabel() {
    addSubview(label)
  }
  
  private func setupLabelConstraints() {
    label.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
    label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    label.widthAnchor.constraint(equalToConstant: 300)
    label.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
