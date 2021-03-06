//
//  CatalogCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 24/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit
import Kingfisher

class CatalogCollectionViewCell: UICollectionViewCell {
  
  var product: Product? {
    didSet {
      clearCell()
      setupCellWithProduct()
    }
  }
  
  var codableProduct: CodableProduct? {
    didSet {
      clearCell()
      setupCellWithProduct()
    }
  }
  
  let numberLabel: UILabel = {
    let label = UILabel()
    label.text = "5"
    label.textColor = ApplicationColors.darkBlue
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Bolle"
    label.textColor = ApplicationColors.darkBlue
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 12, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let priceLabel: UILabel = {
    let label = UILabel()
    label.text = "5000 РУБ."
    label.isOpaque = false
    label.alpha = 0.7
    label.textColor = ApplicationColors.white
    label.textAlignment = .center
    label.backgroundColor = ApplicationColors.darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    return label
  }()
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let availableIndicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .green
    view.layer.cornerRadius = 5
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setWhiteBackgroundColor()
    addSubviews()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addSubviews() {
    addSubviews(imageView)
    imageView.addSubviews(numberLabel, nameLabel, priceLabel, availableIndicatorView)
  }
  
  private func setupConstraints() {
    addConstraints(withFormat: "H:|[v0]|", views: imageView)
    addConstraints(withFormat: "V:|[v0]|", views: imageView)
    
    imageView.addConstraints(withFormat: "H:|[v0(24)]", views: numberLabel)
    imageView.addConstraints(withFormat: "V:|-6-[v0(16)]", views: numberLabel)
    
    imageView.addConstraints(withFormat: "H:|-24-[v0]-24-|", views: nameLabel)
    imageView.addConstraints(withFormat: "V:|-6-[v0(16)]", views: nameLabel)
    
    imageView.addConstraints(withFormat: "H:[v0(90)]|", views: priceLabel)
    imageView.addConstraints(withFormat: "V:[v0(28)]|", views: priceLabel)
    
    imageView.addConstraints(withFormat: "H:|-10-[v0(10)]", views: availableIndicatorView)
    imageView.addConstraints(withFormat: "V:[v0(10)]-10-|", views: availableIndicatorView)
  }
  
  private func clearCell() {
    imageView.image = nil
    nameLabel.text = ""
    numberLabel.text = ""
    priceLabel.text = ""
  }
  
  private func setupCellWithProduct() {
    if let product = product {
      setProductImage()
      nameLabel.text = product.name
      numberLabel.text = String(product.bind)
      priceLabel.text = getPriceText()
      setProductAvailableIndicatorColor()
    } else if let product = codableProduct {
      setProductImage()
      nameLabel.text = product.name
      numberLabel.text = String(product.bind)
      priceLabel.text = getPriceText()
      setProductAvailableIndicatorColor()
    }
  }
  
  private func setProductImage() {
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(with: getImageUrl())
  }
  
  private func getImageUrl() -> URL? {
    if var imageUrlString = product?.img {
      if imageUrlString.hasPrefix("http://020g.ru/ipk/g1") {
        imageUrlString = imageUrlString.replacingOccurrences(of: "g1", with: "g8")
      }
      
      let url = URL(string: imageUrlString)
      return url
    } else if var imageUrlString = codableProduct?.img {
      if imageUrlString.hasPrefix("http://020g.ru/ipk/g1") {
        imageUrlString = imageUrlString.replacingOccurrences(of: "g1", with: "g8")
      }
      
      let url = URL(string: imageUrlString)
      return url
    } else {
      return nil
    }
  }
  
  private func getPriceText() -> String {
    var priceString = ""
    if let cMin = product?.priceMin, let cMax = product?.priceMax {
      if cMin < cMax && cMin != 0 {
        priceString = "от \(cMin) руб."
      } else if cMin == cMax && cMin != 0 {
        priceString = "\(cMin) руб."
      } else if cMin == 0 {
        priceString = "Нет в наличии"
      }
    } else if let cMinString = codableProduct?.priceMin, let cMaxString = codableProduct?.priceMax {
      if let cMin = Int(cMinString), let cMax = Int(cMaxString) {
        if cMin < cMax && cMin != 0 {
          priceString = "от \(cMin) руб."
        } else if cMin == cMax && cMin != 0 {
          priceString = "\(cMin) руб."
        } else if cMin == 0 {
          priceString = "Нет в наличии"
        }
      }
    }
    
    return priceString
  }
  
  private func setProductAvailableIndicatorColor() {
    if let available = product?.available, available {
      setProductAvailableIndicatorGreen()
    } else if let available = codableProduct?.available, available == "1" {
      setProductAvailableIndicatorGreen()
    } else {
      setProductAvailableIndicatorRed()
    }
  }
  
  private func setProductAvailableIndicatorGreen() {
    availableIndicatorView.backgroundColor = ApplicationColors.green
  }
  
  private func setProductAvailableIndicatorRed() {
    availableIndicatorView.backgroundColor = ApplicationColors.red
  }
  
}
