//
//  BreadcrumbsCollectionView.swift
//  020g
//
//  Created by Юрий Истомин on 11/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class BreadcrumbsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  private let cellId = "cellId"
  var breadcrumbs = [Breadcrumb]() {
    didSet {
      reloadData()
      scrollToItem(at: IndexPath(item: breadcrumbs.count - 1, section: 0), at: .left, animated: false)
    }
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    setWhiteBackgroundColor()
    setDelegate()
    setDataSource()
    registerCell()
    setupCollectionViewLayout()
    hideCollectionViewScrollIndicator()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setWhiteBackgroundColor() {
    backgroundColor = ApplicationColors.gray
  }
  
  private func setDelegate() {
    delegate = self
  }
  
  private func setDataSource() {
    dataSource = self
  }
  
  private func registerCell() {
    register(BreadcrumbCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  private func setupCollectionViewLayout() {
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
  
  private func hideCollectionViewScrollIndicator() {
    showsHorizontalScrollIndicator = false
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return breadcrumbs.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = indexPath.item
    let breadcrumb = breadcrumbs[item]
    let isLastCell = item == (breadcrumbs.count - 1)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BreadcrumbCollectionViewCell
    cell.isLastCell = isLastCell
    cell.breadcrumb = breadcrumb
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let breadcrumbName = breadcrumbs[indexPath.item].name + " >"
    let width = computeBreadcrumbWidth(breadcrumbName: breadcrumbName)
    return CGSize(width: width, height: 30)
  }
  
  private func computeBreadcrumbWidth(breadcrumbName name: String) -> CGFloat {
    let initialStringSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20)
    let size = NSString(string: name).boundingRect(with: initialStringSize, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 14)], context: nil)
    
    return size.width + 12
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}
