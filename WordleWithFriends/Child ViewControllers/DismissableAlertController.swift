//
//  DismissableAlertController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/18/22.
//

import UIKit


/// A subclass of `UIAlertController` that can be disabled by tapping outside of the alert
final class DismissableAlertController: UIAlertController {

  private func setupDismissGesture() {
    let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(shouldDismiss))
    self.view.window?.isUserInteractionEnabled = true
    self.view.window?.addGestureRecognizer(tapToDismiss)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupDismissGesture()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.window?.removeAllGestureRecognizers()
  }
  
  @objc private func shouldDismiss(_ target: Any) {
    dismiss(animated: true)
  }
}
