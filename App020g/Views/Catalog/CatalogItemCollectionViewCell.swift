//
//  CatalogueItemCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 24/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit
import Kingfisher

class CatalogItemCollectionViewCell: UICollectionViewCell {
  
  var item: Product? {
    didSet {
      nameLabel.text = item?.name
      numberLabel.text = String(describing: item!.bind)
      priceLabel.text = String(describing: item!.priceMin) + " руб."
      
      if let cMin = item?.priceMin, let cMax = item?.priceMax {
        if cMin < cMax && cMin != 0 {
          priceLabel.text = "от \(cMin) руб."
        } else if cMin == cMax && cMin != 0 {
          priceLabel.text = "\(cMin) руб."
        } else if cMin == 0 {
          priceLabel.text = "Нет в наличии"
        }
      }
      
      if let imageUrl = item?.img, let url = URL(string: imageUrl) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
      }
      
      if let available = item?.available, available {
        availableIndicatorView.backgroundColor = ApplicationColors.green
      } else {
        availableIndicatorView.backgroundColor = ApplicationColors.red
      }
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
  
}
