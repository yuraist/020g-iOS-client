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
  
  let bigGridButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(#imageLiteral(resourceName: "big_grid").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = ApplicationColors.darkBlue
    button.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return button
  }()
  
  let smallGridButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(#imageLiteral(resourceName: "small_grid").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = ApplicationColors.darkBlue
    button.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setWhiteBackgroundColor()
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    addSubviews(smallGridButton, bigGridButton, filterButton, separatorLineView)
    setSubviewsConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setSubviewsConstraints() {
    addConstraints(withFormat: "H:[v0(22)]-8-[v1(22)]-8-[v2(22)]-16-|", views: bigGridButton, smallGridButton, filterButton)
    addConstraints(withFormat: "V:[v0(22)]-10-|", views: filterButton)
    addConstraints(withFormat: "V:[v0(22)]-10-|", views: bigGridButton)
    addConstraints(withFormat: "V:[v0(22)]-10-|", views: smallGridButton)
    addConstraints(withFormat: "H:|[v0]|", views: separatorLineView)
    addConstraints(withFormat: "V:[v0(1)]|", views: separatorLineView)
  }
}
