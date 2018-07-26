//
//  VisiableView.swift
//  ImageScroller
//
//  Created by shengling on 2018/7/24.
//  Copyright © 2018 ShengLing. All rights reserved.
//

import UIKit

class VisiableView: UIView {
    
    var source: DispatchSourceTimer?
    
    var index = 0
    
    var image: UIImage? {
        didSet {
            imageLayer.contents = image?.cgImage
        }
    }
    
    var images: [UIImage] = [] {
        didSet {
            imageLayer.contents = images[index].cgImage
            source?.resume()
        }
    }
    
    let imageLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func doLayout() {
        layer.addSublayer(imageLayer)
        imageLayer.frame = bounds
        source = DispatchSource.makeTimerSource()
        source?.schedule(deadline: DispatchTime.now(), repeating: 2, leeway: DispatchTimeInterval.milliseconds(10))
        source?.setEventHandler(handler: {
            DispatchQueue.main.async {
                let transition = CATransition()
                transition.type = kCATransitionFade
                self.imageLayer.add(transition, forKey: nil)
                self.imageLayer.contents = self.images[self.index % self.images.count].cgImage
                self.index = self.index + 1
            }
        })
        
    }
}
