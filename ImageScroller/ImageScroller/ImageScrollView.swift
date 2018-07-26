//
//  ImageScrollView.swift
//  ImageScroller
//
//  Created by shengling on 2018/7/24.
//  Copyright © 2018 ShengLing. All rights reserved.
//

import UIKit

enum InteractionState: Equatable {
    case touchBegin
    case pan(UIPanGestureRecognizer)
    case idle
}


class ImageScrollView: UIView {
    
    var visiableLayer = CALayer()
    var willShowLayer = CALayer()
    
    open var images: [UIImage] = []
    
    // 当前显示的图片在图片数组中的位置
    var index: Int = 0
    
    enum Horizontal {
        case left, right
    }
    
    var direction: Horizontal = .left
    
    var velocity: CGFloat = 0
    
    var willShowImage: UIImage {
        
        var image: UIImage
        if direction == .left && index == 0 { // 如果是第一个
            image = images.last ?? UIImage()
        } else if direction == .right && index == (images.count - 1) { // 如果是最后一个
            image = images.first ?? UIImage()
        } else if direction == .left {
            image = images[index - 1]
        } else {
            image = images[index + 1]
        }
        
        return image
    }
    
    var newLayer = CALayer()
    
    var visiableOffsetX: CGFloat = 0
    
    var presentationFrame: CGRect!
    
    var state: InteractionState = .idle {
        didSet {
            switch state {
            case .touchBegin:
                // 视图开始被触摸
                print("touchBegin")
                
                //2. 判断 visiableLayer 的 width
//                if visiableLayer.presentation()?.bounds.width == 0  {
//                    let temp = self.visiableLayer
//                    self.visiableLayer = self.willShowLayer
//                    self.willShowLayer = newLayer
//                    temp.removeFromSuperlayer()
//                }
                
                //1. 判断 visiableLayer 的 呈现树 和 图层树是否一致 不一致，将呈现树赋值给图层树
                if visiableLayer.frame.width != visiableLayer.presentation()?.frame.width {
                    if let contentsRect = visiableLayer.presentation()?.contentsRect,
                        let layerFrame = visiableLayer.presentation()?.frame {
                        visiableLayer.contentsRect = contentsRect
                        visiableLayer.frame = layerFrame
                    }
                    presentationFrame = (visiableLayer.presentation()?.frame)!
                } else {
                    presentationFrame = visiableLayer.bounds
                }
                
            case .pan(let pan):
                switch pan.state {
                case .began:
                    print("began")
                case .changed:
                    // 获得手势的偏移向量量
//                    CATransaction.begin()
//                    CATransaction.setDisableActions(true)
                    let translation = pan.translation(in: self)
                    var offsetX = translation.x
                    if presentationFrame.origin.x == 0 {
                        offsetX = presentationFrame.width - bounds.width + translation.x
                    } else {
                        offsetX = presentationFrame.origin.x + translation.x
                    }
                    var rect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
                    print(offsetX)
                    print("translation.x = \(translation.x)")
                    if abs(offsetX) > bounds.width {
                        if offsetX > 0 {
                            offsetX = bounds.width
                        } else {
                            offsetX = -bounds.width
                        }
//                        return
                    }
                    if offsetX > 0 {
                        direction = .left
                        willShowLayer.contents = willShowImage.cgImage
                        rect = CGRect(x: offsetX, y: 0, width: bounds.width - offsetX, height: bounds.height)
                        visiableLayer.contentsRect = CGRect(x: offsetX/bounds.width, y: 0, width: (bounds.width - offsetX) / bounds.width, height: 1)
                    } else {
                        direction = .right
                        willShowLayer.contents = willShowImage.cgImage
                        rect = CGRect(x: 0, y: 0, width: bounds.width + offsetX, height: bounds.height)
                        visiableLayer.contentsRect = CGRect(x: 0, y: 0, width: (bounds.width + offsetX) / bounds.width, height: 1)
                    }
                    visiableLayer.frame = rect
//                    CATransaction.commit()
                    print("changed")
                case .ended:
                    // 获得交互结束时的速度向量
                    willShowLayer.contents = willShowImage.cgImage
                    pan.setTranslation(CGPoint(x: 0, y: 0), in: self)
                    let velocity = pan.velocity(in: self).x
                    let presentationLayerX = (visiableLayer.presentation()?.frame.origin.x)!
                    let presentationLayerWidth = (visiableLayer.presentation()?.frame.width)!
                    // 根据速度向量的大小和方向 以及 呈现树的width 判断 是否应该切换图层
                    
                    // 速度的方向与呈现树运动的方向是否一致
                    let motionSame = (velocity > 0 && presentationLayerX > 0) || (velocity < 0 && presentationLayerX == 0)
                    
                    print("velocity \(velocity)")
                    // 如果速度大于200 并且 速度方向与呈现树的运动方向一致
                    // 或者速度小于200 呈现树的width 大于 self的宽度的二分之一
                    // 那么 就切换视图
                    if abs(velocity) > 200 {
                        if motionSame {
                            self.updateLayer()
                        } else {
                            self.reset()
                        }
                    } else {
                        if presentationLayerWidth < bounds.width / 2 {
                            self.updateLayer()
                        } else {
                            self.reset()
                        }
                    }
                    state = .idle
                    print("ended")
                default: break
                }
            case .idle:
                print("idle")
            }
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ images: [UIImage], frame: CGRect) {
        super.init(frame: frame)
        self.images = images
        doLayout()
    }
    
    func doLayout() {
        configureLayer()
        self.layer.addSublayer(willShowLayer)
        self.layer.addSublayer(visiableLayer)
        addPan()
    }
    
    func configureLayer() {
        willShowLayer.frame = bounds
        visiableLayer.frame = bounds
        visiableLayer.contents = images[index].cgImage
        layer.cornerRadius = 4
        layer.masksToBounds = true
        willShowLayer.contentsGravity = kCAGravityResizeAspectFill
        visiableLayer.contentsGravity = kCAGravityResizeAspectFill
    }
    
    func addPan() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        addGestureRecognizer(pan)
    }
    
    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        state = .pan(pan)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .touchBegin
    }
    
    func reset() {
        CATransaction.begin()
        self.visiableLayer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        self.visiableLayer.frame = self.bounds
        CATransaction.commit()
    }
    
    func updateLayer() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if self.state == .idle {
                self.newLayer = CALayer()
                self.newLayer.frame = self.bounds
                self.newLayer.contentsGravity = kCAGravityResizeAspectFill
                self.layer.insertSublayer(self.newLayer, below: self.willShowLayer)
                let temp = self.visiableLayer
                self.visiableLayer = self.willShowLayer
                self.willShowLayer = self.newLayer
                temp.removeFromSuperlayer()
                if self.direction == .left && self.index == 0 { // 如果是第一个
                    self.index = self.images.count - 1
                } else if self.direction == .right && self.index == (self.images.count - 1) { // 如果是最后一个
                    self.index = 0
                } else if self.direction == .left {
                    self.index = self.index - 1
                } else {
                    self.index = self.index + 1
                }
            }
        }
        if direction == .left {
            visiableLayer.contentsRect = CGRect(x: 1, y: 0, width: 0, height: 1)
            visiableLayer.frame = CGRect(x: bounds.width, y: 0, width: 0, height: bounds.height)
        } else {
            visiableLayer.contentsRect = CGRect(x: 0, y: 0, width: 0, height: 1)
            visiableLayer.frame = CGRect(x: 0, y: 0, width: 0, height: bounds.height)
        }
        CATransaction.commit()
    }
    
    
}

