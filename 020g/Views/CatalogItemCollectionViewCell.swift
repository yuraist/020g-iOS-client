//
//  CatalogueItemCollectionViewCell.swift
//  020g
//
//  Created by Юрий Истомин on 24/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CatalogItemCollectionViewCell: UICollectionViewCell {
  
  var item: Product? {
    didSet {
      nameLabel.text = item?.name
      
      if let cMin = item?.priceMin, let cMax = item?.priceMax {
        if cMin < cMax && cMin != 0 {
          priceLabel.text = "от \(cMin) руб."
        } else if cMin == cMax && cMin != 0 {
          priceLabel.text = "\(cMin)"
        } else if cMin == 0 {
          priceLabel.text = "Нет в наличии"
        }
      }
      priceLabel.text = String(describing: item!.priceMin) + " руб."
      if let imageUrl = item?.img {
        imageView.loadImage(withUrlString: imageUrl)
      }
    }
  }
  
  let numberLabel: UILabel = {
    let label = UILabel()
    label.text = "5"
    label.textColor = ApplicationColors.darkBlue
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 17, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Bolle"
    label.textColor = ApplicationColors.darkBlue
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 17, weight: .light)
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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    imageView.addSubview(numberLabel)
    imageView.addSubview(nameLabel)
    imageView.addSubview(priceLabel)
    
    // Setup imageView's layout constratins
    imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    
    // Setup numberLabel's layout constraints
    numberLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
    numberLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
    numberLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
    numberLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    
    // Setup nameLabel's layout constraints
    nameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
    nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
    nameLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
    nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    // Setup priceLabel's layout constraints
    priceLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
    priceLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    priceLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
    priceLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
