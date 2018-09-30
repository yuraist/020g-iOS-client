//
//  ViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {  return .lightContent }
  
  var isShowingMenu = false {
    didSet {
      if isShowingMenu {
        showShadowForCenterViewController()
      } else {
        hideShadowForCenterViewController()
      }
    }
  }
  
  private let centerPanelExpandedOffset: CGFloat = 100
  
  var centerNavigationController: UINavigationController!
  
  var mainController: UIViewController! {
    didSet {
      setupNavigationController()
    }
  }
  
  var menuViewController: MenuViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMainViewController()
  }
  
  private func setupMainViewController() {
    let layout = UICollectionViewFlowLayout()
    mainController = MainCollectionViewController(collectionViewLayout: layout)
    (mainController as! MainCollectionViewController).delegate = self
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
  
  /// Creates a menuViewController instance and adds it to the viewController
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
    animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
  }
  
  func animateMenuClosing() {
    animateCenterPanelXPosition(targetPosition: 0) { finished in
      self.menuViewController?.view.removeFromSuperview()
      self.menuViewController = nil
    }
  }
  
  /// Animates the center panel sliding in and sliding out
  func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut, animations: {
                    self.centerNavigationController.view.frame.origin.x = targetPosition
    }, completion: completion)
  }
  
  /// Adds and removes a shadow for the center view
  func showShadowForCenterViewController() {
    centerNavigationController.view.layer.shadowOpacity = 0.8
  }
  
  func hideShadowForCenterViewController() {
    centerNavigationController.view.layer.shadowOpacity = 0.0
  }
}

extension ContainerViewController: MenuViewControllerDelegate {
  func didSelect(screen: String) {
    switch screen {
    case "Каталог цен":
      if let _ = centerNavigationController.viewControllers[centerNavigationController.viewControllers.count-1] as? ShopListTableViewController  {
        centerNavigationController.popViewController(animated: true)
      }
    case "Авторизация":
      present(UINavigationController(rootViewController: AuthorizationViewController()), animated: true, completion: nil)
    case "Страйкбольные магазины":
      if let _ = centerNavigationController.viewControllers[centerNavigationController.viewControllers.count-1] as? ShopListTableViewController {
        break
      } else {
        let shopListViewController = ShopListTableViewController()
        shopListViewController.delegate = self
        centerNavigationController.pushViewController(shopListViewController, animated: true)
      }
    case "Задать вопрос":
      present(UINavigationController(rootViewController: AskViewController()), animated: true, completion: nil)
    default:
      return
    }
    toggleLeftPanel()
  }
}
