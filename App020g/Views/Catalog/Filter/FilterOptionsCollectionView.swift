//
//  FilterOptionsCollectionView.swift
//  App020g
//
//  Created by Юрий Истомин on 29/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class FilterOptionsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  private let reuseIdentifier = "cellId"
  
  var parentController: FilterTableViewController?
  
  var filterParameter: FilterParameter? {
    didSet {
      if let options = filterParameter?.options {
        filterOptions = options
      }
    }
  }
  
  var filterOptions = [FilterOption]() {
    didSet {
      reloadData()
    }
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    setWhiteBackgroundColor()
    registerDataSource()
    registerDelegate()
    registerCell()
    disableScroll()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func registerDelegate() {
    delegate = self
  }
  
  private func registerDataSource() {
    dataSource = self
  }
  
  private func registerCell() {
    register(FilterOptionCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  private func disableScroll() {
    isScrollEnabled = false
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filterOptions.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FilterOptionCollectionViewCell
    let option = filterOptions[indexPath.item]
    
    cell.isSelectedCell = false
    cell.option = option
    
    if let filterParameterId = filterParameter?.id {
      if parentController?.selectedParameters[filterParameterId]?.contains(option.value) ?? false {
        cell.isSelectedCell = true
      }
    }
    
    return cell
  }
  
  private func estimateCellWidth(forText text: String) -> CGFloat {
    let textSize = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
    
    return textSize.width + 44
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let optionText = filterOptions[indexPath.row].name
    let optionTextWidth = optionText.estimatedWidth()
    return CGSize(width: optionTextWidth + 16, height: 32)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let parent = parentController, let cell = collectionView.cellForItem(at: indexPath) as? FilterOptionCollectionViewCell {
      cell.isSelectedCell = !cell.isSelectedCell
      let option = filterOptions[indexPath.item]
      
      if let parameterId = filterParameter?.id {
        if cell.isSelectedCell {
          if parent.selectedParameters[parameterId] != nil {
            parent.selectedParameters[parameterId]?.append(option.value)
          } else {
            parent.selectedParameters[parameterId] = [option.value]
          }
        } else {
          parent.selectedParameters[parameterId]?.removeAll(where: { $0 == option.value })
          if parent.selectedParameters[parameterId]?.count == 0 {
            parent.selectedParameters.removeValue(forKey: parameterId)
          }
        }
      }
      
      if parent.selectedParameters.count == 0 {
        parent.acceptFilterView.showOnlyAcceptView()
      } else {
        parent.acceptFilterView.showTwoButtons()
      }
    }
  }
}
