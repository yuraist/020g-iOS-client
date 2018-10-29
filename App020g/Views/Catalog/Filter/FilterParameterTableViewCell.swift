//
//  FilterParameterTableViewCell.swift
//  App020g
//
//  Created by Юрий Истомин on 25/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributes = super.layoutAttributesForElements(in: rect)
    
    var leftMargin = sectionInset.left
    var maxY: CGFloat = -1.0
    attributes?.forEach { layoutAttribute in
      guard layoutAttribute.representedElementCategory == .cell else {
        return
      }
      
      if layoutAttribute.frame.origin.y >= maxY {
        leftMargin = sectionInset.left
      }
      
      layoutAttribute.frame.origin.x = leftMargin
      
      leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
      maxY = max(layoutAttribute.frame.maxY , maxY)
    }
    
    return attributes
  }
}

class FilterParameterTableViewCell: UITableViewCell {
  
  var filterParameter: FilterParameter? {
    didSet {
      clearCell()
      setupCell()
    }
  }
  
  private func clearCell() {
    parameterTitleLabel.text = ""
    filterOptionsCollectionView.filterOptions.removeAll()
  }
  
  private func setupCell() {
    parameterTitleLabel.text = filterParameter?.name
    filterOptionsCollectionView.filterOptions = filterParameter?.options ?? []
  }
  
  private let parameterTitleLabel = FilterParameterNameLabel(text: "", isMainTitle: true)
  
  private let filterOptionsCollectionView = FilterOptionsCollectionView(frame: .zero, collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubviews(parameterTitleLabel, filterOptionsCollectionView)
    setConstraintsForSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraintsForSubviews() {
    parameterTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    parameterTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    parameterTitleLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
    parameterTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    
    filterOptionsCollectionView.leftAnchor.constraint(equalTo: parameterTitleLabel.leftAnchor).isActive = true
    filterOptionsCollectionView.topAnchor.constraint(equalTo: parameterTitleLabel.bottomAnchor, constant: 8).isActive = true
    filterOptionsCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    filterOptionsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
  }
}
