//
//  NavigationAnimator.swift
//  Transition
//
//  Created by 张衡 on 2018/1/3.
//  Copyright © 2018年 张衡. All rights reserved.
//

import UIKit

class NavigationAnimator: NSObject {
    var reverse = false
}

extension NavigationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        let direction: CGFloat = reverse ? -1 : 1
        let const: CGFloat = -0.005
        
        toVC.view.layer.anchorPoint = CGPoint(x: direction == 1 ? 0 : 1, y: 0.5)
        fromVC.view.layer.anchorPoint = CGPoint(x: direction == 1 ? 1 : 0, y: 0.5)
        
        var viewFromTransform: CATransform3D = CATransform3DMakeRotation(direction * .pi/2, 0.0, 1.0, 0.0)
        var viewToTransform: CATransform3D = CATransform3DMakeRotation(-direction * .pi/2, 0.0, 1.0, 0.0)
        viewFromTransform.m34 = const
        viewToTransform.m34 = const
        
        
        containerView.transform = CGAffineTransform(translationX: direction * containerView.frame.size.width / 2.0, y: 0)
        toVC.view.layer.transform = viewToTransform
        containerView.addSubview(toVC.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                
                containerView.transform = CGAffineTransform(translationX: -direction * containerView.frame.size.width / 2.0, y: 0)
                fromVC.view.layer.transform = viewFromTransform
                toVC.view.layer.transform = CATransform3DIdentity
        },
            completion: { _ in
                
                containerView.transform = CGAffineTransform.identity
                fromVC.view.layer.transform = CATransform3DIdentity
                toVC.view.layer.transform = CATransform3DIdentity
                fromVC.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                toVC.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                
                if (transitionContext.transitionWasCancelled) {
                    toVC.view.removeFromSuperview()
                } else {
                    fromVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        )
    }
    
    
}
