//
//  CustomNavigationController.swift
//  SampleApp
//
//  Created by bruno on 7/22/25.
//

import UIKit


class CustomNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInteractivePopGesture()
    }
    
    private func setupInteractivePopGesture() {
        // interactivePopGestureRecognizer 활성화
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
           let poppedVC = super.popViewController(animated: animated)
            AppDelegate.main.router.syncPathOnPop()
           return poppedVC
       }
       
       override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
           let poppedVCs = super.popToViewController(viewController, animated: animated)
           
           // 여러 개가 pop된 경우
           if let count = poppedVCs?.count {
               for _ in 0..<count {
                   AppDelegate.main.router.syncPathOnPop()
               }
           }
           return poppedVCs
       }
       
       override func popToRootViewController(animated: Bool) -> [UIViewController]? {
           let poppedVCs = super.popToRootViewController(animated: animated)
           AppDelegate.main.router.syncPathOnPopToRoot()
           return poppedVCs
       }
}
