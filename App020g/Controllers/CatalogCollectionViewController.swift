//
//  CatalogCollectionViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CatalogCollectionViewController: UICollectionViewController {
  
  private let filterBarView = FilterBarView(frame: .zero)
  
  var category: CatalogTreeChildCategory?
  var filter: FilterRequest?
  var products = [CodableProduct]()
  
  var isShowingLargeCells = false {
    didSet {
      collectionView.collectionViewLayout.invalidateLayout()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.setGrayBackgroundColor()
    setNavigationBarTitle()
    registerCollectionViewCell()
    addFilterBarView()
    setFilterButtonAction()
    setFilterBarViewConstraints()
    setCollectionViewConstraints()
    fetchProducts()
  }
  
  private func setNavigationBarTitle() {
    navigationItem.title = category?.name ?? ""
  }
  
  private func registerCollectionViewCell() {
    collectionView.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  private func addFilterBarView() {
    view.addSubview(filterBarView)
  }
  
  private func setFilterButtonAction() {
    filterBarView.bigGridButton.addTarget(self, action: #selector(showLargeGrid), for: .touchUpInside)
    filterBarView.smallGridButton.addTarget(self, action: #selector(showSmallGrid), for: .touchUpInside)
    filterBarView.filterButton.addTarget(self, action: #selector(showFilterController), for: .touchUpInside)
  }
  
  @objc
  private func showLargeGrid() {
    isShowingLargeCells = true
  }
  
  @objc
  private func showSmallGrid() {
    isShowingLargeCells = false
  }
  
  @objc
  private func showFilterController() {
    let filterController = FilterTableViewController()
    filterController.parentController = self
    show(filterController, sender: self)
  }
  
  private func setFilterBarViewConstraints() {
    filterBarView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    filterBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: getTopLayoutGuide()).isActive = true
    filterBarView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    filterBarView.heightAnchor.constraint(equalToConstant: 42).isActive = true
  }
  
  private func setCollectionViewConstraints() {
    collectionView.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    collectionView.topAnchor.constraint(equalTo: filterBarView.bottomAnchor).isActive = true
    collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  private func getTopLayoutGuide() -> CGFloat {
    return UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.size.height ?? 0)
  }
  
  private func fetchProducts() {
    guard let category = category else {
      return
    }
    
    if filter == nil {
      filter = FilterRequest(category: "\(category.id)", page: "1", cost: nil, options: nil, sort: nil)
    }
    
    ApiHandler.shared.fetchFilteredProducts(withFilter: filter!) { (response) in
      if let catalogResponse = response {
        self.products.append(contentsOf: catalogResponse.list)
        self.reloadCollectionView()
      }
    }
  }
  
  private func reloadCollectionView() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CatalogCollectionViewCell
    cell.codableProduct = products[indexPath.item]
    return cell
  }
}

extension CatalogCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let minSize = CGSize(width: collectionView.frame.size.width/2 - 1, height: collectionView.frame.size.width/2 - 2)
    let bigSize = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width - 2)
    return isShowingLargeCells ? bigSize : minSize
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return isShowingLargeCells ? 2 : 1
  }
}
