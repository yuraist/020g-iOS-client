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
  
  var viewModel: CatalogViewModel
  
  var isShowingLargeCells = false {
    didSet {
      collectionView.collectionViewLayout.invalidateLayout()
    }
  }
  
  init(_ viewModel: CatalogViewModel) {
    self.viewModel = viewModel
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.setGrayBackgroundColor()
    setNavigationBarTitle()
    
    addFilterBarView()
    setFilterButtonsActions()
    setFilterBarViewConstraints()
    
    registerCollectionViewCell()
    setCollectionViewConstraints()
    
    setupViewModelObserving()
    fetchProducts()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if viewModel.filter.options != nil {
      let filledFilterImage = #imageLiteral(resourceName: "filter_filled").withRenderingMode(.alwaysTemplate)
      filterBarView.filterButton.setImage(filledFilterImage, for: .normal)
    } else {
      let filledFilterImage = #imageLiteral(resourceName: "filter").withRenderingMode(.alwaysTemplate)
      filterBarView.filterButton.setImage(filledFilterImage, for: .normal)
    }
  }
  
  private func setNavigationBarTitle() {
    navigationItem.title = viewModel.categoryName
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
  
  private func getTopLayoutGuide() -> CGFloat {
    return UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.size.height ?? 0)
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
    
    ServerManager.shared.fetchFilter(forCategoryId: Int(viewModel.filter.category)!) { [unowned self] (response) in
      if response != nil {
        DispatchQueue.main.async {
          let filterViewModel = FilterViewModel(filterResponse: response!, categoryId: Int(self.viewModel.filter.category)!, sortingType: self.viewModel.sorting.value)
          let filterController = FilterTableViewController(viewModel: filterViewModel)
          filterController.parentController = self
          
          self.show(filterController, sender: self)
        }
      }
    }
  }
  
  @objc
  private func showSortingTypePicker() {
    let sortingTypeActionSheet = UIAlertController(title: "Сортировать", message: nil, preferredStyle: .actionSheet)
    
    let newFirstAction = UIAlertAction(title: "Сначала новые", style: .default) { [unowned self] _ in
      self.viewModel.sorting.value = .newFirst
    }
    let oldFirstAction = UIAlertAction(title: "Сначала старые", style: .default) { [unowned self] _ in
      self.viewModel.sorting.value = .oldFirst
    }
    let chipFirstAction = UIAlertAction(title: "Сначала дешевые", style: .default) { [unowned self] _ in
      self.viewModel.sorting.value = .chipFirst
    }
    let expensiveFirstAction = UIAlertAction(title: "Сначала дорогие", style: .default) { [unowned self] _ in
      self.viewModel.sorting.value = .expensiveFirst
    }
    let groupedFirstAction = UIAlertAction(title: "Сначала сгруппированные", style: .default) { [unowned self] _ in
      self.viewModel.sorting.value = .groupedFirst
    }
    let ungroupedFirstAction = UIAlertAction(title: "Сначала несгруппированные", style: .default) { [unowned self] _ in
      self.viewModel.sorting.value = .ungroupedFirst
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
  
  private func registerCollectionViewCell() {
    collectionView.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  private func setCollectionViewConstraints() {
    collectionView.setTranslatesAutoresizingMaskIntoConstraintsFalse()
    collectionView.topAnchor.constraint(equalTo: filterBarView.bottomAnchor).isActive = true
    collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  private func setupViewModelObserving() {
    observeProductsChanges()
    observeSortingTypeChanges()
  }
  
  private func observeProductsChanges() {
    viewModel.products.bind { [unowned self] (products) in
      DispatchQueue.main.async {
        self.reloadCollectionView()
      }
    }
  }
  
  private func reloadCollectionView() {
    collectionView.reloadData()
  }
  
  private func observeSortingTypeChanges() {
    viewModel.sorting.bind { [unowned self] (sortingType) in
      self.viewModel.filter.sort = sortingType.rawValue
      self.changeDropDownMenu(sortingType: sortingType)
      self.fetchProducts()
    }
  }
  
  private func fetchProducts() {
    viewModel.fetchNewProducts()
  }
  
  private func changeDropDownMenu(sortingType sorting: SortingType) {
    filterBarView.dropDownSortingMenu.change(sortingType: sorting)
    scrollCollectionViewToTop()
  }
  
  private func scrollCollectionViewToTop() {
    collectionView.contentOffset = CGPoint(x: 0, y: 0)
  }
  
  func update(filter: FilterRequest) {
    viewModel.filter = filter
    fetchProducts()
  }
 }

// MARK: - Data Source

extension CatalogCollectionViewController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfProducts
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CatalogCollectionViewCell
    cell.codableProduct = viewModel.products.value[indexPath.item]
    
    if last(index: indexPath) {
      viewModel.fetchNextPage()
    }
    
    return cell
  }
  
  private func last(index indexPath: IndexPath) -> Bool {
    return indexPath.item == viewModel.numberOfProducts - 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let product = viewModel.getProduct(at: indexPath)
    
    viewModel.fetch(selectedProduct: product) { [unowned self] (product) in
      if let product = product {
        self.showProductTableViewController(productResponse: product)
      }
    }
  }
  
  private func showProductTableViewController(productResponse: ProductResponse) {
    let productTableViewController = ProductTableViewController(response: productResponse)
    show(productTableViewController, sender: self)
  }
}

// MARK: - Delegate Flow Layout

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
