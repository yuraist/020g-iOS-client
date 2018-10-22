//
//  ProductPriceCell.swift
//  020g
//
//  Created by Юрий Истомин on 09/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ProductPriceCell: UITableViewCell {
  
  var price: Price? {
    didSet {
      clearCell()
      setupCell()
    }
  }
  
  private static let fontSize: CGFloat = 14
  
  private let shopLabel: UILabel = {
    let label = UILabel()
    label.textColor = ApplicationColors.darkGray
    label.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let availableLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.textColor = ApplicationColors.darkGray
    label.font = UIFont.systemFont(ofSize: fontSize)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    setCellSelectionStyleNone()
    addSubviews()
    setupConstraintsForLabels()
  }
  
  private func setCellSelectionStyleNone() {
    selectionStyle = .none
  }
  
  private func clearCell() {
    backgroundColor = ApplicationColors.white
    availableLabel.textColor = ApplicationColors.darkGray
    priceLabel.text = ""
  }
  
  private func setupCell() {
    if let price = price {
      
      setShopLabelText()
      setPriceLabelText()
      
      if price.isAvailable {
        setGreenBackgroundColor()
        setGreenAvailableLabel()
        setAvailableLabelPositiveText()
      } else {
        setRedBackgroundColor()
        setRedAvailableLabel()
        setAvailableLabelNegativeText()
      }
    }
  }
  
  private func setShopLabelText() {
    shopLabel.text = price!.site
  }
  
  private func setPriceLabelText() {
    priceLabel.text = price!.price
  }
  
  private func setGreenBackgroundColor() {
    backgroundColor = ApplicationColors.lighterGreen
  }
  
  private func setRedBackgroundColor() {
    backgroundColor = ApplicationColors.lighterRed
  }
  
  private func setGreenAvailableLabel() {
    availableLabel.textColor = ApplicationColors.green
  }
  
  private func setRedAvailableLabel() {
    availableLabel.textColor = ApplicationColors.red
  }
  
  private func setAvailableLabelPositiveText() {
    availableLabel.text = "в наличии"
  }
  
  private func setAvailableLabelNegativeText() {
    availableLabel.text = "нет в наличии"
  }
  
  private func addSubviews() {
    addSubview(shopLabel)
    addSubview(priceLabel)
    addSubview(availableLabel)
  }
  
  private func setupConstraintsForLabels() {
    shopLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
    shopLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    shopLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
    shopLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    priceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -6).isActive = true
    priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    priceLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
    priceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    availableLabel.rightAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -2).isActive = true
    availableLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    availableLabel.leftAnchor.constraint(equalTo: shopLabel.rightAnchor, constant: 2).isActive = true
    availableLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
