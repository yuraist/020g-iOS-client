//
//  DropDownSortingMenu.swift
//  App020g
//
//  Created by Юрий Истомин on 28/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

enum SortingType: String {
  case newFirst = "upd-1"
  case oldFirst = "upd-0"
  case chipFirst = "cst-1"
  case expensiveFirst = "cst-0"
  case groupedFirst = "pop-1"
  case ungroupedFirst = "pop-0"
}

class DropDownSortingMenu: UIView {
  
  private let sortingTitles: [SortingType: String] = [.newFirst: "Сначала новые",
                                                       .oldFirst: "Сначала старые",
                                                       .chipFirst: "Сначала дорогие",
                                                       .expensiveFirst: "Сначала дешевые",
                                                       .groupedFirst: "Сначала сгруппированные",
                                                       .ungroupedFirst: "Сначала несгруппированные"]
  
  private var sortingType: SortingType = .newFirst {
    didSet {
      changeTriangleImage()
      changeLabelTitle()
    }
  }
  
  let selectSortingTypeLabel: UILabel = {
    let label = UILabel()
    label.text = "Сначала новые"
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = ApplicationColors.buttonBlue
    label.isUserInteractionEnabled = true
    label.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return label
  }()
  
  private let triangle: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "up").withRenderingMode(.alwaysTemplate))
    imageView.tintColor = ApplicationColors.buttonBlue
    imageView.isUserInteractionEnabled = true
    imageView.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    isUserInteractionEnabled = true
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    addSubviews(selectSortingTypeLabel, triangle)
    setConstraintsForSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraintsForSubviews() {
    selectSortingTypeLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    selectSortingTypeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    selectSortingTypeLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
    selectSortingTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    triangle.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    triangle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    triangle.widthAnchor.constraint(equalToConstant: 10).isActive = true
    triangle.heightAnchor.constraint(equalToConstant: 10).isActive = true
  }
  
  func change(sortingType type: SortingType) {
    sortingType = type
  }
  
  func getCurrentSortingType() -> SortingType {
    return sortingType
  }
  
  private func changeTriangleImage() {
    switch sortingType {
    case .newFirst, .chipFirst, .groupedFirst:
      triangle.image = #imageLiteral(resourceName: "up").withRenderingMode(.alwaysTemplate)
    default:
      triangle.image = #imageLiteral(resourceName: "down").withRenderingMode(.alwaysTemplate)
    }
  }
  
  private func changeLabelTitle() {
    selectSortingTypeLabel.text = sortingTitles[sortingType]
  }
}
