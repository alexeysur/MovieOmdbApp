//
//  LaunchScreenViewController.swift
//  MovieOMDbApp
//
//  Created by Alexey on 6/26/19.
//  Copyright © 2019 Alexey. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let blankView = UIView()
        blankView.frame.size = CGSize(width: 200, height: 200)
        blankView.center = view.center
        
        let gradient = CAGradientLayer(layer: blankView.layer)
        gradient.colors = [UIColor.orange.cgColor, UIColor.blue.cgColor]
        gradient.locations = [0,1]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:0, y:1)
        gradient.frame = blankView.bounds
        
        blankView.layer.insertSublayer(gradient, at: 0)
        view.addSubview(blankView)
    }
    

 
}
