//
//  ViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  var centerNavigationController: UINavigationController!
  var menuViewController: MenuViewController?
  
  var mainController: CenterViewController! {
    didSet {
      setupNavigationController()
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {  return .lightContent }
  private let centerPanelExpandedOffset: CGFloat = 100
  
  var isShowingMenu = false {
    didSet {
      if isShowingMenu {
        showShadowForCenterViewController()
      } else {
        hideShadowForCenterViewController()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMainViewController()
  }
  
  private func setupMainViewController() {
    mainController = MainCollectionViewController()
    mainController.delegate = self
  }
  
  private func setupNavigationController() {
    initializeCenterNavigationController()
    showCenterNavigationController()
    setupNavigationControllerStyle()
  }
  
  private func initializeCenterNavigationController() {
    centerNavigationController = UINavigationController(rootViewController: mainController)
  }
  
  private func showCenterNavigationController() {
    view.addSubview(centerNavigationController.view)
    addChild(centerNavigationController)
    centerNavigationController.didMove(toParent: self)
  }
  
  private func setupNavigationControllerStyle() {
    centerNavigationController.navigationBar.barTintColor = ApplicationColors.darkBlue
    centerNavigationController.navigationBar.tintColor = ApplicationColors.white
    centerNavigationController.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: ApplicationColors.white
      ] as [NSAttributedString.Key: Any]
  }
}

// MARK: CenterViewController delegate

extension ContainerViewController: CenterViewControllerDelegate {
  func toggleLeftPanel() {
    if !isShowingMenu {
      addLeftPanelViewController()
    }
    
    if isShowingMenu {
      animateMenuClosing()
    } else {
      animateMenuOpening()
    }
    
    isShowingMenu = !isShowingMenu
  }
  
  func addLeftPanelViewController() {
    guard menuViewController == nil else { return }
    initializeMenuViewController()
    showMenuViewController()
  }
  
  private func initializeMenuViewController() {
    menuViewController = MenuViewController()
    menuViewController!.delegate = self
  }
  
  private func showMenuViewController() {
    addChild(menuViewController: menuViewController!)
  }
  
  func addChild(menuViewController: MenuViewController) {
    view.insertSubview(menuViewController.view, at: 0)
    addChild(menuViewController)
    menuViewController.didMove(toParent: self)
  }
  
  func animateMenuOpening() {
    animateCenterPanelXPosition(targetPosition: computeCenterPanelTargetPositionForOpeningMenu())
  }
  
  func animateMenuClosing() {
    animateCenterPanelXPosition(targetPosition: computeCenterPanelTargetPositionForClosingMenu()) { finished in
      self.removeMenuViewController()
    }
  }
  
  private func computeCenterPanelTargetPositionForOpeningMenu() -> CGFloat {
    return centerNavigationController.view.frame.width - centerPanelExpandedOffset
  }
  
  private func computeCenterPanelTargetPositionForClosingMenu() -> CGFloat {
    return 0
  }
  
  private func removeMenuViewController() {
    self.menuViewController?.view.removeFromSuperview()
    self.menuViewController = nil
  }
  
  func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut, animations: {
                    self.centerNavigationController.view.frame.origin.x = targetPosition
    }, completion: completion)
  }
  
  func showShadowForCenterViewController() {
    centerNavigationController.view.layer.shadowOpacity = 0.8
  }
  
  func hideShadowForCenterViewController() {
    centerNavigationController.view.layer.shadowOpacity = 0.0
  }
}

// MARK: - MenuViewControllerDelegate

extension ContainerViewController: MenuViewControllerDelegate {
  func didSelect(screen: String) {
    switch screen {
    case "Каталог цен":
      showMainViewController()
    case "Авторизация":
      showAuthorizationViewController()
    case "Страйкбольные магазины":
      guard let _ = centerNavigationController.viewControllers[centerNavigationController.viewControllers.count-1] as? ShopsCollectionViewController else {
        showShopListTableViewController()
        break
      }
    case "Задать вопрос":
      showAskViewController()
    default:
      return
    }
    toggleLeftPanel()
  }
  
  private func showMainViewController() {
    if let _ = centerNavigationController.viewControllers[centerNavigationController.viewControllers.count-1] as? ShopsCollectionViewController  {
      centerNavigationController.popViewController(animated: true)
    }
  }
  
  private func showAuthorizationViewController() {
    present(UINavigationController(rootViewController: AuthorizationViewController()), animated: true, completion: nil)
  }
  
  private func showShopListTableViewController() {
    centerNavigationController.pushViewController(initializeShopListTableViewController(), animated: true)
  }
  
  private func initializeShopListTableViewController() -> ShopsCollectionViewController {
    let shopListTableViewController = ShopsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    shopListTableViewController.delegate = self
    return shopListTableViewController
  }
  
  private func showAskViewController() {
    present(UINavigationController(rootViewController: AskViewController()), animated: true, completion: nil)
  }
}
