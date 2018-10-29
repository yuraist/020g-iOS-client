//
//  FilterParameterTableViewCell.swift
//  App020g
//
//  Created by Юрий Истомин on 25/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class FilterParameterTableViewCell: UITableViewCell {
  
  var filterParameter: FilterParameter? {
    didSet {
      clearCell()
      setupCell()
    }
  }
  
  private func clearCell() {
    
  }
  
  private func setupCell() {
    parameterTitleLabel.text = filterParameter?.name
  }
  
  private let parameterTitleLabel = FilterParameterNameLabel(text: "", isMainTitle: true)
  
  private let filterOptionsCollectionView = FilterOptionsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubviews(parameterTitleLabel, filterOptionsCollectionView)
    setConstraintsForSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraintsForSubviews() {
    parameterTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    parameterTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    parameterTitleLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
    parameterTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    
    filterOptionsCollectionView.leftAnchor.constraint(equalTo: parameterTitleLabel.leftAnchor).isActive = true
    filterOptionsCollectionView.topAnchor.constraint(equalTo: parameterTitleLabel.bottomAnchor, constant: 8).isActive = true
    filterOptionsCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    filterOptionsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
  }
}

class FilterOptionsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  private let reuseIdentifier = "cellId"
  
  var filterOptions: [FilterOption]? {
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
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FilterOptionCollectionViewCell
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: 32)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }
}

class FilterOptionCollectionViewCell: UICollectionViewCell {
  
  var option: FilterOption? {
    didSet {
      
    }
  }
  
  override var isSelected: Bool {
    didSet {
      changeBackgroundColor()
      changeTextColor()
    }
  }
  
  private let optionLabel: UILabel = {
    let label = UILabel()
    label.text = "Test 1"
    label.textColor = ApplicationColors.buttonBlue
    label.layer.cornerRadius = 3
    label.layer.masksToBounds = true
    label.layer.borderColor = ApplicationColors.buttonBlue.cgColor
    label.layer.borderWidth = 1
    label.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(optionLabel)
    setOptionLabelConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setOptionLabelConstraints() {
    optionLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    optionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    optionLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    optionLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
  }
  
  private func changeBackgroundColor() {
    optionLabel.backgroundColor = isSelected ? ApplicationColors.buttonBlue : ApplicationColors.white
  }
  
  private func changeTextColor() {
    optionLabel.textColor = isSelected ? ApplicationColors.white : ApplicationColors.buttonBlue
  }
}
