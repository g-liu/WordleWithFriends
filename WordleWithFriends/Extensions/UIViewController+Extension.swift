//
//  UIViewController+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/4/22.
//

import UIKit

extension UIViewController {
  private var toastAnimationSpeed: TimeInterval { 0.08 }
  
  func presentToast(_ text: String, duration: TimeInterval = 2.0) {
    let toastView = ToastView(text: text)
    view.addSubview(toastView)
    view.bringSubviewToFront(toastView)
    
    let swipeToDismissGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDismissToast))
    swipeToDismissGesture.direction = .up
    toastView.addGestureRecognizer(swipeToDismissGesture)
    
    NSLayoutConstraint.activate([
      toastView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    ])
    
    let totalDisplayedTime = max(2*toastAnimationSpeed, duration - 2*toastAnimationSpeed)
    
    UIView.animate(withDuration: toastAnimationSpeed, delay: 0, options: [.curveEaseOut]) {
      toastView.transform = CGAffineTransform(translationX: 0, y: 52)
    } completion: { [weak self] finished in
      guard let self = self else {
        toastView.removeFromSuperview()
        return
      }
      self.animateDismissToast(toastView, delay: totalDisplayedTime)
    }
  }
  
  @objc private func swipeToDismissToast(_ sender: UISwipeGestureRecognizer) {
    guard let toastView = sender.view as? ToastView else { return }
    
    animateDismissToast(toastView)
  }
  
  private func animateDismissToast(_ toastView: ToastView, delay: TimeInterval = 0) {
    UIView.animate(withDuration: self.toastAnimationSpeed, delay: delay, options: [.curveEaseOut]) {
      toastView.transform = CGAffineTransform(translationX: 0, y: 0)
    } completion: { finished2 in
      toastView.removeFromSuperview()
    }
  }
  
  func dismissAllToasts() {
    view.subviews.forEach { subview in
      guard let toastView = subview as? ToastView else { return }
      toastView.removeFromSuperview()
    }
  }
}
