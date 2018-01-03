//
//  NavigationInteractor.swift
//  Transition
//
//  Created by 张衡 on 2018/1/2.
//  Copyright © 2018年 张衡. All rights reserved.
//

import UIKit

class PopInteractor: UIPercentDrivenInteractiveTransition {

    var navigationController: UINavigationController!
    
    var hasStarted = false
    var shouldFinish = false
    
    func attachToViewController(viewController: UIViewController) {
        navigationController = viewController.navigationController
        setupGestureRecognizer(view: viewController.view)
    }
    
    private func setupGestureRecognizer(view: UIView) {
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gestureRecognizer:))))
    }
    
    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        let viewTranslation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        
        switch gestureRecognizer.state {
        case .began:
            hasStarted = true
            navigationController.popViewController(animated: true)
        case .changed:
            let const = CGFloat(fminf(fmaxf(Float(viewTranslation.x / 200.0), 0.0), 1.0))
            shouldFinish = const > 0.5
            update(const)
        case .cancelled, .ended:
            hasStarted = false
            if !shouldFinish || gestureRecognizer.state == .cancelled {
                cancel()
            } else {
                finish()
            }
        default:
            break
        }
    }
}
