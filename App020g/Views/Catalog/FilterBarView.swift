//
//  FilterBarView.swift
//  App020g
//
//  Created by Юрий Истомин on 25/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class FilterBarView: UIView {
  
  private let separatorLineView: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.lightGray
    view.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return view
  }()
  
  let filterButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(#imageLiteral(resourceName: "filter").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = ApplicationColors.darkBlue
    button.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return button
  }()
  
  let sizeSwitch: UISwitch = {
    let sizeSwitch = UISwitch(frame: .zero)
    sizeSwitch.isOn = false
    sizeSwitch.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return sizeSwitch
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setWhiteBackgroundColor()
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    addSubviews(sizeSwitch, filterButton, separatorLineView)
    setSubviewsConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setSubviewsConstraints() {
    addConstraints(withFormat: "H:[v0(51)]-[v1(22)]-16-|", views: sizeSwitch, filterButton)
    addConstraints(withFormat: "V:[v0(22)]-10-|", views: filterButton)
    addConstraints(withFormat: "V:[v0(31)]-5-|", views: sizeSwitch)
    addConstraints(withFormat: "H:|[v0]|", views: separatorLineView)
    addConstraints(withFormat: "V:[v0(1)]|", views: separatorLineView)
  }
}
