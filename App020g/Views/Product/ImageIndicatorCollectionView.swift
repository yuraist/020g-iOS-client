//
//  ImageIndicatorCollectionView.swift
//  App020g
//
//  Created by Юрий Истомин on 15/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ImageIndicatorCollectionViewCell: UICollectionViewCell {
  
  static let indicatorSize: CGFloat = 8
  
  var indicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.white
    view.layer.cornerRadius = indicatorSize / 2
    view.layer.masksToBounds = true
    view.layer.borderWidth = 1
    view.layer.borderColor = ApplicationColors.darkBlue.cgColor
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override var isSelected: Bool {
    didSet {
      resetAppearance()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    setWhiteBackgroundColor()
    addIndicatorView()
    setupIndicatorViewConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addIndicatorView() {
    addSubview(indicatorView)
  }
  
  private func setupIndicatorViewConstraints() {
    addConstraints(withFormat: "H:|[v0(8)]|", views: indicatorView)
    addConstraints(withFormat: "V:|[v0(8)]|", views: indicatorView)
  }
  
  private func resetAppearance() {
    indicatorView.backgroundColor = isSelected ? ApplicationColors.darkBlue : ApplicationColors.white
  }
}

class ImageIndicatorCollectionView: UICollectionView {
  private let cellId = "cellId"
  private let numberOfImages: Int
  
  var selectedImageNumber: Int {
    didSet {
      setCellDeselected(oldValue)
      setCellSelected()
    }
  }
  
  init(numberOfImages: Int) {
    self.numberOfImages = numberOfImages
    self.selectedImageNumber = 0
    super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    registerCell()
    setupCollectionViewDelegateAndDataSource()
    setHorizontalScrollDirection()
    setClearBackgroundColor()
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func registerCell() {
    register(ImageIndicatorCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  private func setupCollectionViewDelegateAndDataSource() {
    delegate = self
    dataSource = self
  }
  
  private func setHorizontalScrollDirection() {
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
  
  private func setCellDeselected(_ oldValue: Int) {
    let cell = getCell(forItem: oldValue)
    cell?.isSelected = false
  }
  
  private func setCellSelected() {
    let cell = getCell(forItem: selectedImageNumber)
    cell?.isSelected = true
  }
  
  private func getCell(forItem item: Int) -> UICollectionViewCell? {
    let indexPath = IndexPath(item: item, section: 0)
    let cell = cellForItem(at: indexPath)
    return cell
  }
}


extension ImageIndicatorCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfImages
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageIndicatorCollectionViewCell
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return ImageIndicatorCollectionViewCell.indicatorSize
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: ImageIndicatorCollectionViewCell.indicatorSize, height: ImageIndicatorCollectionViewCell.indicatorSize)
  }
}
