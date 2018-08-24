//
//  ViewController.swift
//  Keyframe
//
//  Created by implion on 2018/8/24.
//  Copyright © 2018年 private. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        let bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        let circleView = UIView()
        circleView.center = CGPoint(x: 30, y: UIScreen.main.bounds.height / 2)
        circleView.bounds = bounds
        circleView.layer.cornerRadius = 10
        circleView.backgroundColor = .green
        view.addSubview(circleView)
        
        let circleView2 = UIView()
        circleView2.backgroundColor = .red
        circleView2.center = CGPoint(x: 30, y: UIScreen.main.bounds.height / 2 - 40)
        circleView2.bounds = bounds
        circleView2.layer.cornerRadius = 10
        view.addSubview(circleView2)
        
        let circleView3 = UIView()
        circleView3.backgroundColor = .orange
        circleView3.center = CGPoint(x: 30, y: UIScreen.main.bounds.height / 2 + 40)
        circleView3.bounds = bounds
        circleView3.layer.cornerRadius = 10
        view.addSubview(circleView3)
        
        
        KeyframeAnimation.default.create(circleView.layer, values: [30.0, Float(UIScreen.main.bounds.width - 30)], timeingFuntion: .bounceEaseOut)
        KeyframeAnimation.default.create(circleView2.layer, values: [30.0, Float(UIScreen.main.bounds.width - 30)], timeingFuntion: .quadIn)
        KeyframeAnimation.default.create(circleView3.layer, values: [30.0, Float(UIScreen.main.bounds.width - 30)], timeingFuntion: .quintOut)

    }

}

