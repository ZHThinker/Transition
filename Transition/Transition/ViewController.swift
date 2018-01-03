//
//  ViewController.swift
//  Transition
//
//  Created by 张衡 on 2017/12/29.
//  Copyright © 2017年 张衡. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let dismissInteractor = DismissInteractor()
    let presentInteractor = PresentInteractor()
    let popInteractor = PopInteractor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showHelperCircle()
    }
    
    @IBAction func handleGestureRecognize(_ sender: UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.3
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        switch sender.state {
        case .began:
            presentInteractor.hasStarted = true
            performSegue(withIdentifier: "Present", sender: nil)
        case .changed:
            presentInteractor.shouldFinish = progress > percentThreshold
            presentInteractor.update(progress)
        case .cancelled:
            presentInteractor.hasStarted = false
            view.alpha = 1
            presentInteractor.cancel()
        case .ended:
            presentInteractor.hasStarted = false
            presentInteractor.shouldFinish ? presentInteractor.finish() : presentInteractor.cancel()
        default:
            break
        }
    }
    
    func showHelperCircle() {
        let center1 = CGPoint(x: view.bounds.width * 0.5 - 15, y: 100)
        let small = CGSize(width: 30, height: 30)
        let circle1 = UIView(frame: CGRect(origin: center1, size: small))
        circle1.layer.cornerRadius = circle1.frame.width/2
        circle1.backgroundColor = UIColor.white
        circle1.layer.shadowOpacity = 0.8
        circle1.layer.shadowOffset = CGSize()
        
        let center2 = CGPoint(x: view.bounds.width * 0.7, y: view.bounds.height * 0.75)
        let circle2 = UIView(frame: CGRect(origin: center2, size: small))
        circle2.layer.cornerRadius = circle2.frame.width/2
        circle2.backgroundColor = UIColor.white
        circle2.layer.shadowOpacity = 0.8
        circle2.layer.shadowOffset = CGSize()
        
        view.addSubview(circle1)
//        view.addSubview(circle2)
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0.25,
            options: [],
            animations: {
                circle1.frame.origin.y += 200
                circle1.layer.opacity = 0
                
                circle2.frame.origin.x -= 200
                circle2.layer.opacity = 0
        },
            completion: { _ in
                circle1.removeFromSuperview()
                circle2.removeFromSuperview()
        }
        )
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Present" {
            let destination = segue.destination as! PresentedController
            destination.transitioningDelegate = self
            dismissInteractor.attachToViewController(viewController: destination)
        }
        
        if segue.identifier == "Push" {
            navigationController?.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentInteractor.hasStarted ? presentInteractor : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissInteractor.hasStarted ? dismissInteractor : nil
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            popInteractor.attachToViewController(viewController: toVC)
        }
        let animator = NavigationAnimator()
        animator.reverse = operation == .pop
        return animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return popInteractor.hasStarted ? popInteractor : nil
    }
}

