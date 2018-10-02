//
//  ShopInfoFieldView.swift
//  020g
//
//  Created by Юрий Истомин on 02/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ShopInfoFieldView: UIView {
  let label: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17, weight: .light)
    label.textColor = ApplicationColors.gray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  init(info: String) {
    super.init(frame: .zero)
    setInfoToLabel(info)
    addLabelToView()
    setupLabelConstraints()
  }
  
  private func setInfoToLabel(_ info: String) {
    label.text = info
  }
  
  private func addLabelToView() {
    addSubview(label)
  }
  
  private func setupLabelConstraints() {
    label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
    label.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

