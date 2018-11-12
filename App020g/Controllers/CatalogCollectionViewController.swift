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
  
  var filter: FilterRequest? {
    didSet {
      products = []
      fetchProducts()
    }
  }
  
  var sorting: SortingType = .chipFirst {
    didSet {
      filterBarView.dropDownSortingMenu.change(sortingType: sorting)
      filter?.sort = sorting.rawValue
    }
  }
  
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
    setFilterButtonsActions()
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
  
  private func setFilterBarViewConstraints() {
    filterBarView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    filterBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: getTopLayoutGuide()).isActive = true
    filterBarView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    filterBarView.heightAnchor.constraint(equalToConstant: 42).isActive = true
  }
  
  private func setFilterButtonsActions() {
    filterBarView.largeGridButton.addTarget(self, action: #selector(showLargeGrid), for: .touchUpInside)
    filterBarView.smallGridButton.addTarget(self, action: #selector(showSmallGrid), for: .touchUpInside)
    filterBarView.filterButton.addTarget(self, action: #selector(showFilterController), for: .touchUpInside)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSortingTypePicker))
    filterBarView.dropDownSortingMenu.addGestureRecognizer(tapGesture)
  }
  
  @objc
  private func showLargeGrid() {
    isShowingLargeCells = true
    filterBarView.largeGridButton.setImage(#imageLiteral(resourceName: "large_grid_filled").withRenderingMode(.alwaysTemplate), for: .normal)
    filterBarView.smallGridButton.setImage(#imageLiteral(resourceName: "small_grid").withRenderingMode(.alwaysTemplate), for: .normal)
  }
  
  @objc
  private func showSmallGrid() {
    isShowingLargeCells = false
    filterBarView.largeGridButton.setImage(#imageLiteral(resourceName: "large_grid").withRenderingMode(.alwaysTemplate), for: .normal)
    filterBarView.smallGridButton.setImage(#imageLiteral(resourceName: "small_grid_filled").withRenderingMode(.alwaysTemplate), for: .normal)
  }
  
  @objc
  private func showFilterController() {
    let filterController = FilterTableViewController()
    filterController.parentController = self
    show(filterController, sender: self)
  }
  
  @objc
  private func showSortingTypePicker() {
    let sortingTypeActionSheet = UIAlertController(title: "Сортировать", message: nil, preferredStyle: .actionSheet)
    
    let newFirstAction = UIAlertAction(title: "Сначала новые", style: .default) { [unowned self] _ in
      self.sorting = .newFirst
    }
    let oldFirstAction = UIAlertAction(title: "Сначала старые", style: .default) { [unowned self] _ in
      self.sorting = .oldFirst
    }
    let chipFirstAction = UIAlertAction(title: "Сначала дешевые", style: .default) { [unowned self] _ in
      self.sorting = .chipFirst
    }
    let expensiveFirstAction = UIAlertAction(title: "Сначала дорогие", style: .default) { [unowned self] _ in
      self.sorting = .expensiveFirst
    }
    let groupedFirstAction = UIAlertAction(title: "Сначала сгруппированные", style: .default) { [unowned self] _ in
      self.sorting = .groupedFirst
    }
    let ungroupedFirstAction = UIAlertAction(title: "Сначала несгруппированные", style: .default) { [unowned self] _ in
      self.sorting = .ungroupedFirst
    }
    
    let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
    
    sortingTypeActionSheet.addAction(newFirstAction)
    sortingTypeActionSheet.addAction(oldFirstAction)
    sortingTypeActionSheet.addAction(chipFirstAction)
    sortingTypeActionSheet.addAction(expensiveFirstAction)
    sortingTypeActionSheet.addAction(groupedFirstAction)
    sortingTypeActionSheet.addAction(ungroupedFirstAction)
    sortingTypeActionSheet.addAction(cancelAction)
    
    present(sortingTypeActionSheet, animated: true, completion: nil)
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
    
    ServerManager.shared.fetchFilteredProducts(withFilter: filter!) { (response) in
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
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = indexPath.item
    let product = products[item]
    let productId = Int(product.id)!
    
    ServerManager.shared.getProduct(withId: productId) { (success, productResponse) in
      if let productResponse = productResponse {
        DispatchQueue.main.async {
          self.showProductTableViewController(productResponse: productResponse)
        }
      }
    }
  }
  
  private func showProductTableViewController(productResponse: ProductResponse) {
    let productTableViewController = ProductTableViewController(response: productResponse)
    show(productTableViewController, sender: self)
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
