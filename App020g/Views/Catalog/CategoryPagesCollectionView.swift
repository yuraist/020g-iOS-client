//
//  CategoryPagesCollectionView.swift
//  App020g
//
//  Created by Юрий Истомин on 16/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CategoryPagesCollectionView: UICollectionView {
  
  private let cellId = "cell"
  private var contentOffsets = [Int: CGPoint]()
  
  var parentViewController: MainViewController?
  
  var categories = [Category]() {
    didSet {
      DispatchQueue.main.async {
        self.reloadData()
      }
    }
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    registerCell()
    setDelegate()
    setDataSource()
    setPagingEnabled()
    setHorizontalScrollDirection()
    setWhiteBackgroundColor()
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func registerCell() {
    register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  private func setDelegate() {
    delegate = self
  }
  
  private func setDataSource() {
    dataSource = self
  }
  
  private func setPagingEnabled() {
    isPagingEnabled = true
  }
  
  private func setHorizontalScrollDirection() {
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    sendNotificationAboutChangingCategory()
  }
  
  private func sendNotificationAboutChangingCategory() {
    let categoryIndex = getCurrentCategoryIndex()
    NotificationCenter.default.post(name: .categoryChanged, object: categoryIndex)
  }
 
  private func getCurrentCategoryIndex() -> Int {
    if let cell = visibleCells.first, let indexPath = indexPath(for: cell) {
      return indexPath.item
    }
    return 0
  }
  
  private func getCurrentVisibleCell() -> CategoryCollectionViewCell? {
    return visibleCells.first as? CategoryCollectionViewCell
  }
}

extension CategoryPagesCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCollectionViewCell
    
    cell.catalogCollectionView.category = nil
    cell.catalogCollectionView.products = []
    cell.catalogCollectionView.parentViewController = nil
    
    let category = categories[indexPath.item]
    
    cell.catalogCollectionView.category = category
    cell.catalogCollectionView.parentViewController = parentViewController
    
    if let currentOffset = parentViewController?.contentOffsets[category.cat] {
      cell.catalogCollectionView.contentOffset = currentOffset
    } else {
      cell.catalogCollectionView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    // TODO :- Implement the contentOffset saving
    let categoryId = categories[indexPath.item].cat
    let currentOffset = (cell as! CategoryCollectionViewCell).catalogCollectionView.contentOffset
    parentViewController?.contentOffsets[categoryId] = currentOffset
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return frame.size
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}
