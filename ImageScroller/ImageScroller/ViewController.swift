//
//  ViewController.swift
//  ImageScroller
//
//  Created by shengling on 2018/7/24.
//  Copyright © 2018 ShengLing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let imageNames = ["image01.jpg", "image02.jpg", "image03.jpg", "image04.jpg"]
    
    let visiableView = VisiableView(frame: CGRect(x: 0, y: 400, width: UIScreen.main.bounds.width, height: 200))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageScrollView = ImageScrollView(imageNames.map { UIImage(named: $0) ?? UIImage() }, frame: CGRect(x: 40, y: 40, width: UIScreen.main.bounds.width - 80, height: 120))
        view.addSubview(imageScrollView)
        
        
//        visiableView.image = UIImage(named: imageNames[3])
        view.addSubview(visiableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        visiableView.images = imageNames.map { UIImage(named: $0) ?? UIImage() }
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            DispatchQueue.main.async {
//                self.visiableView.visiableRect = CGRect(x: 0, y: 0, width: 200, height: 200)
//            }
//        }
    }
    

}

