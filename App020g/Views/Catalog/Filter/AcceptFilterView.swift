//
//  AcceptFilterView.swift
//  App020g
//
//  Created by Юрий Истомин on 30/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class AcceptFilterView: UIView {
  
  private let acceptView = CustomLabeledImageView(withImage: #imageLiteral(resourceName: "ok"), andTitle: "Готово")
  private let cancelView = CustomLabeledImageView(withImage: #imageLiteral(resourceName: "cancel"), andTitle: "Очистить")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    setWhiteBackgroundColor()
    addSubviews(acceptView, cancelView)
    setConstraintsForSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraintsForSubviews() {
    cancelView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    cancelView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    cancelView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -20).isActive = true
    cancelView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    acceptView.leftAnchor.constraint(equalTo: cancelView.rightAnchor, constant: 8).isActive = true
    acceptView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    acceptView.widthAnchor.constraint(equalTo: cancelView.widthAnchor).isActive = true
    acceptView.heightAnchor.constraint(equalToConstant: 36).isActive = true
  }
}
