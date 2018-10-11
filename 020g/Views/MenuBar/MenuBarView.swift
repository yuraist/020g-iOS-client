//
//  MenuBarView.swift
//  020g
//
//  Created by Юрий Истомин on 24/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MenuBarView: UIView {
  
  private let cellId = "menuBarCellId"
  
  let pricesButton = StandardButton(title: "Каталог цен")
  
  var catalogCollectionView: UICollectionView?
  var height: CGFloat { return frame.size.height }
  
  var selectedItemIndexPath = IndexPath(item: 0, section: 0) {
    didSet {
      deselectOldItem(indexPath: oldValue)
      selectNewItem()
      scrollCollectionViewToNewPosition()
    }
  }
  
  var categories = [Category]() {
    didSet {
      reloadCollectionView()
    }
  }
  
  let centerButtonView: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColors.white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    cv.backgroundColor = ApplicationColors.violet
    cv.translatesAutoresizingMaskIntoConstraints = false
    return cv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setTranslatesAutoresizingMaskIntoConstraintsFalse()
    
    addSubviews()
    setupConstraintsOfSubviews()
    setupCollectionView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setTranslatesAutoresizingMaskIntoConstraintsFalse() {
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func addSubviews() {
    addSubview(centerButtonView)
    addSubview(pricesButton)
    addSubview(collectionView)
  }
  
  private func setupConstraintsOfSubviews() {
    setupCenterButtonViewConstraints()
    setupPriceButtonConstraints()
    setupCollectionViewConstratints()
  }
  
  private func setupCenterButtonViewConstraints() {
    centerButtonView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    centerButtonView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    centerButtonView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    centerButtonView.heightAnchor.constraint(equalToConstant: 52).isActive = true
  }
  
  private func setupPriceButtonConstraints() {
    pricesButton.leftAnchor.constraint(equalTo: centerButtonView.leftAnchor, constant: 8).isActive = true
    pricesButton.topAnchor.constraint(equalTo: centerButtonView.topAnchor, constant: 8).isActive = true
    pricesButton.rightAnchor.constraint(equalTo: centerButtonView.rightAnchor, constant: -8).isActive = true
    pricesButton.bottomAnchor.constraint(equalTo: centerButtonView.bottomAnchor, constant: -8).isActive = true
  }
  
  private func setupCollectionViewConstratints() {
    collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    collectionView.topAnchor.constraint(equalTo: centerButtonView.bottomAnchor).isActive = true
    collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    collectionView.heightAnchor.constraint(equalToConstant: 32).isActive = true
  }
  
  func setupCollectionView() {
    setCollectionViewDelegate()
    setCollectionViewDataSource()
    removeScrollIndicator()
    registerCollectionViewCell()
    setupCollectionViewLayout()
  }
  
  private func setCollectionViewDelegate() {
    collectionView.delegate = self
  }
  
  private func setCollectionViewDataSource() {
    collectionView.dataSource = self
  }
  
  private func removeScrollIndicator() {
    collectionView.showsHorizontalScrollIndicator = false
  }
  
  private func registerCollectionViewCell() {
    collectionView.register(MenuBarCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  private func setupCollectionViewLayout() {
    if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      collectionViewLayout.scrollDirection = .horizontal
      collectionViewLayout.minimumLineSpacing = 0
      collectionViewLayout.minimumInteritemSpacing = 0
    }
  }
  
  func reloadCollectionView() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
      self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
    }
  }
  
  private func deselectOldItem(indexPath: IndexPath) {
    collectionView.cellForItem(at: indexPath)?.isSelected = false
  }
  
  private func selectNewItem() {
    collectionView.cellForItem(at: selectedItemIndexPath)?.isSelected = true
  }
  
  private func scrollCollectionViewToNewPosition() {
    collectionView.scrollToItem(at: selectedItemIndexPath, at: .centeredHorizontally, animated: true)
  }
  
}

extension MenuBarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuBarCollectionViewCell
    cell.textLabel.text = categories[indexPath.item].title
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedItemIndexPath = indexPath
    catalogCollectionView?.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
  }
  
  private func getCellWidth(forString string: String) -> CGFloat {
    let stringSize = (string as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)])
    return stringSize.width + 30
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let categoryName = categories[indexPath.item].title
    let width = getCellWidth(forString: categoryName)
    return CGSize(width: width, height: 32)
  }
  
}
