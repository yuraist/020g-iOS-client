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
  
  private var acceptViewWidthAnchor: NSLayoutConstraint?
  private var acceptViewLeftAnchor: NSLayoutConstraint?
  private var cancelViewWidthAnchor: NSLayoutConstraint?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    setWhiteBackgroundColor()
    addSubviews(acceptView, cancelView)
    setConstraintsForSubviews()
    showOnlyAcceptView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraintsForSubviews() {
    cancelView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    cancelView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    cancelViewWidthAnchor = cancelView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -20)
    cancelViewWidthAnchor?.isActive = true
    cancelView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    acceptViewLeftAnchor = acceptView.leftAnchor.constraint(equalTo: cancelView.rightAnchor, constant: 8)
    acceptViewLeftAnchor?.isActive = true
    acceptView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    acceptViewWidthAnchor = acceptView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -20)
    acceptViewWidthAnchor?.isActive = true
    acceptView.heightAnchor.constraint(equalToConstant: 36).isActive = true
  }
  
  func showOnlyAcceptView() {
    cancelViewWidthAnchor?.isActive = false
    acceptViewWidthAnchor?.isActive = false
    acceptViewLeftAnchor?.isActive = false
    
    cancelViewWidthAnchor = cancelView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0)
    acceptViewWidthAnchor = acceptView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40)
    acceptViewLeftAnchor = acceptView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16)
    
    cancelViewWidthAnchor?.isActive = true
    acceptViewWidthAnchor?.isActive = true
    acceptViewLeftAnchor?.isActive = true
  }
  
  func showTwoButtons() {
    cancelViewWidthAnchor?.isActive = false
    acceptViewWidthAnchor?.isActive = false
    acceptViewLeftAnchor?.isActive = false
    
    cancelViewWidthAnchor = cancelView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -20)
    acceptViewWidthAnchor = acceptView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -20)
    acceptViewLeftAnchor = acceptView.leftAnchor.constraint(equalTo: cancelView.rightAnchor, constant: 8)
    
    cancelViewWidthAnchor?.isActive = true
    acceptViewWidthAnchor?.isActive = true
    acceptViewLeftAnchor?.isActive = true
  }
}
