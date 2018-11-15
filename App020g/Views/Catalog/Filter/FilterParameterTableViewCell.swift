//
//  FilterParameterTableViewCell.swift
//  App020g
//
//  Created by Юрий Истомин on 25/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit
import DGCollectionViewLeftAlignFlowLayout

class FilterParameterTableViewCell: UITableViewCell {
  
  var parentController: FilterViewController?
  
  var filterParameter: FilterParameter? {
    didSet {
      clearCell()
      setupCell()
    }
  }
  
  private func clearCell() {
    parameterTitleLabel.text = ""
    filterOptionsCollectionView.filterParameter = nil
    filterOptionsCollectionView.filterOptions.removeAll()
  }
  
  private func setupCell() {
    parameterTitleLabel.text = filterParameter?.name
    filterOptionsCollectionView.filterParameter = filterParameter
    filterOptionsCollectionView.parentController = parentController
  }
  
  private let parameterTitleLabel = FilterParameterNameLabel(text: "", isMainTitle: true)
  
  private lazy var filterOptionsCollectionView: FilterOptionsCollectionView = {
    let layout = DGCollectionViewLeftAlignFlowLayout()
    let cv = FilterOptionsCollectionView(frame: .zero, collectionViewLayout: layout)
    cv.parentController = parentController
    cv.filterParameter = filterParameter
    return cv
  }()
  
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
    parameterTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
    parameterTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    
    filterOptionsCollectionView.leftAnchor.constraint(equalTo: parameterTitleLabel.leftAnchor).isActive = true
    filterOptionsCollectionView.topAnchor.constraint(equalTo: parameterTitleLabel.bottomAnchor, constant: 8).isActive = true
    filterOptionsCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    filterOptionsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
  }
}
