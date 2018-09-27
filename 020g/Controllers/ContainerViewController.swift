//
//  ViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

/// The main controller contains views of the controllers to be presented on the screen at the current time
class ContainerViewController: UIViewController {
  
  // Set light status bar color
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  /// A variable to define that a side menu is showing or not
  var isShowMenu = false {
    didSet {
      showShadowForCenterViewController(shouldShowShadow: isShowMenu)
    }
  }
  
  private let centerPanelExpandedOffset: CGFloat = 100
  
  /// A navigation controller contains the center controller
  var centerNavigationController: UINavigationController!
  
  /// Center controller
  var mainController: UIViewController!
  
  /// A controller represents a side menu view
  var menuViewController: MenuViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ApplicationColor.midBlue
    
    // Setup the mainViewController
    setupMainViewController()
    
    // Setup navigation controller
    setupNavigationController()
    setupNavigationControllerStyle()
  }
  
  /// Initiates a MainCollectionViewController instance and set it to the mainController property.
  /// Current controller is set as the mainController's delegate.
  private func setupMainViewController() {
    let layout = UICollectionViewFlowLayout()
    mainController = MainCollectionViewController(collectionViewLayout: layout)
    (mainController as! MainCollectionViewController).delegate = self
  }
  
  /// Creates a UINavigationController instance and adds its view into the current view.
  private func setupNavigationController() {
    // Create a new navigation controller
    centerNavigationController = UINavigationController(rootViewController: mainController)
    
    // Setup parent-child relationship
    view.addSubview(centerNavigationController.view)
    addChild(centerNavigationController)
    centerNavigationController.didMove(toParent: self)
  }
  
  /// Set a color and a title color for the navigation bar
  private func setupNavigationControllerStyle() {
    centerNavigationController.navigationBar.barTintColor = ApplicationColor.darkBlue
    centerNavigationController.navigationBar.tintColor = ApplicationColor.white
    centerNavigationController.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: ApplicationColor.white] as [NSAttributedString.Key: Any]
  }
}

// MARK: CenterViewController delegate

/// Implementation of the CenterViewControllerDelegate's methods
extension ContainerViewController: CenterViewControllerDelegate {
  func toggleLeftPanel() {
    if !isShowMenu {
      addLeftPanelViewController()
    }
    
    animateLeftPanel(shouldExpand: !isShowMenu)
  }
  
  /// Creates a menuViewController instance and adds it to the viewController
  func addLeftPanelViewController() {
    guard menuViewController == nil else { return }
    
    let vc = MenuViewController()
    addChild(sidePanelController: vc)
    menuViewController = vc
  }
  
  /// Adds the side panel controller's view below the container controller's view
  func addChild(sidePanelController: MenuViewController) {
    view.insertSubview(sidePanelController.view, at: 0)
    addChild(sidePanelController)
    sidePanelController.didMove(toParent: self)
  }
  
  /// Changes the isShowMenu property and call the center panel animation
  /// and removes view of the menu controller if the animation is sliding out
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
  func showShadowForCenterViewController(shouldShowShadow: Bool) {
    if shouldShowShadow {
      centerNavigationController.view.layer.shadowOpacity = 0.8
    } else {
      centerNavigationController.view.layer.shadowOpacity = 0.0
    }
  }
}
