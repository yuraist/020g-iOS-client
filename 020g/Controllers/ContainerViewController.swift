//
//  ViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  var isShowMenu = false {
    didSet {
      showShadowForCenterViewController(shouldShowShadow: isShowMenu)
    }
  }
  
  let centerPanelExpandedOffset: CGFloat = 100
  
  // Add additional controllers
  var centerNavigationController: UINavigationController!
  var mainController: MainTableViewController!
  var menuViewController: MenuViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ApplicationColor.midBlue
    
    // Setup mainViewController
    mainController = MainTableViewController()
    mainController.delegate = self
    
    // Setup navigation controller
    setupNavigationController()
    setupNavigationControllerStyle()
  }
  
  private func setupNavigationController() {
    // Create a new navigation controller
    centerNavigationController = UINavigationController(rootViewController: mainController)
    
    // Setup parent-child relationship
    view.addSubview(centerNavigationController.view)
    addChild(centerNavigationController)
    centerNavigationController.didMove(toParent: self)
  }
  
  // Set the style for teh navigation bar
  private func setupNavigationControllerStyle() {
    centerNavigationController.navigationBar.barTintColor = ApplicationColor.darkBlue
    centerNavigationController.navigationBar.tintColor = ApplicationColor.white
    centerNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ApplicationColor.white] as [NSAttributedString.Key: Any]
  }
  
}

// MARK: CenterViewController delegate

extension ContainerViewController: CenterViewControllerDelegate {
  func toggleLeftPanel() {
    if !isShowMenu {
      addLeftPanelViewController()
    }
    
    animateLeftPanel(shouldExpand: !isShowMenu)
  }
  
  // Creates a menuViewController instance and adds it to the viewController
  func addLeftPanelViewController() {
    guard menuViewController == nil else { return }
    
    let vc = MenuViewController()
    addChild(sidePanelController: vc)
    menuViewController = vc
  }
  
  // Adds the side panel controller's view below the container controller's view
  func addChild(sidePanelController: MenuViewController) {
    view.insertSubview(sidePanelController.view, at: 0)
    addChild(sidePanelController)
    sidePanelController.didMove(toParent: self)
  }
  
  func animateLeftPanel(shouldExpand: Bool) {
    if shouldExpand {
      isShowMenu = !isShowMenu
      animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
    } else {
      animateCenterPanelXPosition(targetPosition: 0) { finished in
        self.isShowMenu = !self.isShowMenu
        self.menuViewController?.view.removeFromSuperview()
        self.menuViewController = nil
      }
    }
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
  
  func showShadowForCenterViewController(shouldShowShadow: Bool) {
    if shouldShowShadow {
      centerNavigationController.view.layer.shadowOpacity = 0.8
    } else {
      centerNavigationController.view.layer.shadowOpacity = 0.0
    }
  }
}
