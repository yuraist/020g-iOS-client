//
//  MenuBarView.swift
//  020g
//
//  Created by Юрий Истомин on 24/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MenuBarView: UIView {
  
  let centerButtonView: UIView = {
    let view = UIView()
    view.backgroundColor = ApplicationColor.white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let pricesButton = StandardButton(title: "Каталог цен")
  
  let collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    cv.backgroundColor = ApplicationColor.violet
    cv.translatesAutoresizingMaskIntoConstraints = false
    return cv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    addSubview(centerButtonView)
    addSubview(pricesButton)
    addSubview(collectionView)
    
    // Setup the centerButtonView's layout constraints
    centerButtonView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    centerButtonView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    centerButtonView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    centerButtonView.heightAnchor.constraint(equalToConstant: 52).isActive = true
    
    // Setup the pricesButton's layout constraints
    pricesButton.leftAnchor.constraint(equalTo: centerButtonView.leftAnchor, constant: 8).isActive = true
    pricesButton.topAnchor.constraint(equalTo: centerButtonView.topAnchor, constant: 8).isActive = true
    pricesButton.rightAnchor.constraint(equalTo: centerButtonView.rightAnchor, constant: -8).isActive = true
    pricesButton.bottomAnchor.constraint(equalTo: centerButtonView.bottomAnchor, constant: -8).isActive = true
    
    // Setup the collectionView's layout constraints
    collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    collectionView.topAnchor.constraint(equalTo: centerButtonView.bottomAnchor).isActive = true
    collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    collectionView.heightAnchor.constraint(equalToConstant: 28).isActive = true
  }
  
}
