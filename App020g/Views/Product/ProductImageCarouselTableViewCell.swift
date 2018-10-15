//
//  ProductImageCarouselTableViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 09/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ProductImageCarouselTableViewCell: UITableViewCell {
  
  private let cellId = "imageCell"
  private let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  lazy var imageIndicator: ImageIndicatorCollectionView? = {
    if let numberOfImages = imageUrls?.count {
      let imageIndicator = ImageIndicatorCollectionView(numberOfImages: numberOfImages)
      return imageIndicator
    }
    return nil
  }()
  
  var imageUrls: [String]? {
    didSet {
      addImageIndicatorAndSetup()
      setResizedImageUrls()
    }
  }
  
  var resizedImageUrls: [String]? {
    didSet {
      imageCollectionView.reloadData()
    }
  }
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setCellSelectionStyleNone()
    addImageCollectionView()
    setupImageCollectionView()
  }
  
  private func setCellSelectionStyleNone() {
    selectionStyle = .none
  }
  
  private func addImageCollectionView() {
    addSubview(imageCollectionView)
  }
  
  private func setupImageCollectionView() {
    setImageCollectionViewWhiteBackgroundColor()
    setupConstraintsForImageCollectionView()
    setSelfAsImageCollectionViewDelegate()
    setSelfAsImageCollectionViewDataSource()
    registerCellForImageCollectionView()
    setImageCollectionViewPaging()
    setImageCollectionViewHorizontalScrollDirection()
    removeImageCollectionViewScrollIndicator()
  }
  
  private func setImageCollectionViewWhiteBackgroundColor() {
    imageCollectionView.backgroundColor = ApplicationColors.white
  }
  
  private func setupConstraintsForImageCollectionView() {
    imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
    imageCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    imageCollectionView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    imageCollectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    imageCollectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
  }

  private func setSelfAsImageCollectionViewDelegate() {
    imageCollectionView.delegate = self
  }
  
  private func setSelfAsImageCollectionViewDataSource() {
    imageCollectionView.dataSource = self
  }
  
  private func registerCellForImageCollectionView() {
    imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  private func setImageCollectionViewPaging() {
    imageCollectionView.isPagingEnabled = true
  }
  
  private func setImageCollectionViewHorizontalScrollDirection() {
    if let layout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
  
  private func removeImageCollectionViewScrollIndicator() {
    imageCollectionView.showsHorizontalScrollIndicator = false
  }
  
  private func setResizedImageUrls() {
    if let imageUrls = imageUrls {
      resizedImageUrls = imageUrls.map { (imageUrl) -> String in
        return getResizedImageUrl(withCurrentImageUrl: imageUrl)
      }
    }
  }
  
  private func getResizedImageUrl(withCurrentImageUrl url: String) -> String {
    return url.replacingOccurrences(of: "g1", with: "g2")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addImageIndicatorAndSetup() {
    if imageIndicator != nil {
      addSubview(imageIndicator!)
      addConstraints(withFormat: "H:|-10-[v0]|", views: imageIndicator!)
      addConstraints(withFormat: "V:[v0(10)]-10-|", views: imageIndicator!)
    }
  }
}

extension ProductImageCarouselTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return resizedImageUrls?.count ?? 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCollectionViewCell
    
    if let imageUrlString = resizedImageUrls?[indexPath.item], let imageUrl = URL(string: imageUrlString) {
      cell.imageView.kf.setImage(with: imageUrl)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: frame.size.width, height: frame.size.width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
