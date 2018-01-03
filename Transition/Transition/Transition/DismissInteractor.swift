//
//  DismissInteractor.swift
//  Transition
//
//  Created by 张衡 on 2018/1/2.
//  Copyright © 2018年 张衡. All rights reserved.
//

import UIKit

class DismissInteractor: UIPercentDrivenInteractiveTransition {
    
    var controller: UIViewController!
    
    var hasStarted = false
    var shouldFinish = false
    
    func attachToViewController(viewController: UIViewController) {
        setupGestureRecognizer(view: viewController.view)
        controller = viewController
    }
    
    private func setupGestureRecognizer(view: UIView) {
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gestureRecognizer:))))
    }
    
    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.3
        
        let translation = gestureRecognizer.translation(in: controller.view)
        let verticalMovement = translation.y / controller.view.bounds.height
        
        // 上滑
        let downwardMovement = fminf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(-downwardMovement, 1.0)
        
        // 下滑
//        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
//        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        
        let progress = CGFloat(downwardMovementPercent)
        
        switch gestureRecognizer.state {
        case .began:
            hasStarted = true
            controller.dismiss(animated: true, completion: nil)
        case .changed:
            shouldFinish = progress > percentThreshold
            update(progress)
            
        case .cancelled:
            hasStarted = false
            cancel()
        case .ended:
            hasStarted = false
            shouldFinish ? finish() : cancel()
        default:
            break
        }
    }
}
