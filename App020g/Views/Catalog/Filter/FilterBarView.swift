//
//  FilterBarView.swift
//  App020g
//
//  Created by Юрий Истомин on 25/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class FilterBarView: UIView {
  
  let dropDownSortingMenu = DropDownSortingMenu(frame: .zero)
  
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
  
  let largeGridButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(#imageLiteral(resourceName: "large_grid").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = ApplicationColors.buttonBlue
    button.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return button
  }()
  
  let smallGridButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(#imageLiteral(resourceName: "small_grid_filled").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = ApplicationColors.buttonBlue
    button.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setWhiteBackgroundColor()
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    addSubviews(dropDownSortingMenu, smallGridButton, largeGridButton, filterButton, separatorLineView)
    setSubviewsConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setSubviewsConstraints() {
    dropDownSortingMenu.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    dropDownSortingMenu.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    dropDownSortingMenu.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
    dropDownSortingMenu.heightAnchor.constraint(equalTo: heightAnchor, constant: -4).isActive = true
    
    addConstraints(withFormat: "H:[v0(22)]-8-[v1(22)]-8-[v2(22)]-16-|", views: largeGridButton, smallGridButton, filterButton)
    addConstraints(withFormat: "V:[v0(22)]-10-|", views: filterButton)
    addConstraints(withFormat: "V:[v0(22)]-10-|", views: largeGridButton)
    addConstraints(withFormat: "V:[v0(22)]-10-|", views: smallGridButton)
    addConstraints(withFormat: "H:|[v0]|", views: separatorLineView)
    addConstraints(withFormat: "V:[v0(1)]|", views: separatorLineView)
  }
}
