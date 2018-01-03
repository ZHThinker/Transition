//
//  PushedController.swift
//  Transition
//
//  Created by 张衡 on 2017/12/29.
//  Copyright © 2017年 张衡. All rights reserved.
//

import UIKit

class PushedController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showHelperCircle()
    }
    
    func showHelperCircle() {
        let center1 = CGPoint(x: view.bounds.width * 0.25, y: view.bounds.height * 0.5)
        let small = CGSize(width: 30, height: 30)
        let circle1 = UIView(frame: CGRect(origin: center1, size: small))
        circle1.layer.cornerRadius = circle1.frame.width/2
        circle1.backgroundColor = UIColor.white
        circle1.layer.shadowOpacity = 0.8
        circle1.layer.shadowOffset = CGSize()
        
        
        view.addSubview(circle1)
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0.25,
            options: [],
            animations: {
                circle1.frame.origin.x += 200
                circle1.layer.opacity = 0
        },
            completion: { _ in
                circle1.removeFromSuperview()
        }
        )
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
