//
//  PresentAnimator.swift
//  Transition
//
//  Created by 张衡 on 2017/12/29.
//  Copyright © 2017年 张衡. All rights reserved.
//

import UIKit

class PresentAnimator: NSObject {

}

extension PresentAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from)
            else {
                return
        }
        transitionContext.containerView.addSubview(toVC.view)
        
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: -screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        toVC.view.frame = finalFrame
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                toVC.view.frame = screenBounds
                fromVC.view.alpha = 0.8
        },
            completion: { _ in
                fromVC.view.alpha = 1
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        )
    }
}
