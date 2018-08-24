//
//  KeyframeAnimation.swift
//  Keyframe
//
//  Created by implion on 2018/8/24.
//  Copyright © 2018年 private. All rights reserved.
//

import Foundation
import UIKit

class KeyframeAnimation: NSObject {
    
    static let `default` = KeyframeAnimation()
    
    var compltionBlock: ((Bool) -> ())?
    
    enum EaseFunction {
        case linear
        case quadIn
        case quadOut
        case quadInOut
        case cubicIn
        case cubicOut
        case cubicInOut
        case quartIn
        case quartOut
        case quartInOut
        case quintIn
        case quintOut
        case quintInOut
        case sinIn
        case sinOut
        case sinInOut
        case bounceEaseOut
        
        func values(start: Float, end: Float, duration: Float) -> [NSNumber] {
            let distance = end - start
            let numberFrames = duration * 60
            var frames: [NSNumber] = []
            let array = 1..<Int(numberFrames)
            var function: ((Float)->(Float))
            switch self {
            case .linear:
                function = linear(_:)
            case .quadIn:
                function = quadIn(_:)
            case .quadOut:
                function = quadOut(_:)
            case .quadInOut:
                function = quadInOut(_:)
            case .cubicIn:
                function = cubicIn(_:)
            case .cubicOut:
                function = cubicOut(_:)
            case .cubicInOut:
                function = cubicInOut(_:)
            case .quartIn:
                function = quartIn(_:)
            case .quartOut:
                function = quartOut(_:)
            case .quartInOut:
                function = quartInOut(_:)
            case .quintIn:
                function = quintIn(_:)
            case .quintOut:
                function = quintOut(_:)
            case .quintInOut:
                function = quintInOut(_:)
            case .sinIn:
                function = sinIn(_:)
            case .sinOut:
                function = sinOut(_:)
            case .sinInOut:
                function = sinInOut(_:)
            case .bounceEaseOut:
                function = bounceEaseOut(_:)
            }
            
            for i in array {
                let t = 1.0 / numberFrames * Float(i)
                frames.append(NSNumber(value: start +  (function(t) * distance)))
            }
            frames.append(NSNumber(value: end))
            return frames
        }
        
        func linear(_ t: Float) -> Float {
            return t
        }
        
        func quadIn(_ t: Float) -> Float {
            return t * t
        }
        
        func quadOut(_ t: Float) -> Float {
            return t * (2 - t)
        }
        
        func quadInOut(_ t: Float) -> Float {
            return t < 0.5 ? (2 * t * t) : (-1 + (4 - 2 * t) * t)
        }
        
        func cubicIn(_ t: Float) -> Float {
            return t * t * t
        }
        
        func cubicOut(_ t: Float) -> Float {
            return 1 - cubicIn(1 - t)
        }
        
        func cubicInOut(_ t: Float) -> Float {
            return t < 0.5 ? (4 * t * t * t) : ((t - 1) * (2 * t - 2) * (2 * t - 2) + 1)
        }
        
        func quartIn(_ t: Float) -> Float {
            return t * t * t * t
        }
        
        func quartOut(_ t: Float) -> Float {
            return 1 - quartIn(1-t)
        }
        
        func quartInOut(_ t: Float) -> Float {
            return t < 0.5 ? (8 * t * t * t * t) : (1 - 8 * (t - 1) * t * t * t)
        }
        
        func quintIn(_ t: Float) -> Float {
            return t * t * t * t * t
        }
        
        func quintOut(_ t: Float) -> Float {
            return 1 - quintIn(1-t)
        }
        
        func quintInOut(_ t: Float) -> Float {
            return t < 0.5 ? (16 * t * t * t * t * t) : (1 + 16 * (t - 1) * t * t * t * t)
        }
        
        func sinIn(_ t: Float) -> Float {
            return 1 + sin(Float.pi / 2 * t - Float.pi / 2)
        }
        
        func sinOut(_ t: Float) -> Float {
            return sin(Float.pi / 2 * t)
        }
        
        func sinInOut(_ t: Float) -> Float {
            return (1 + sin(Float.pi * t - Float.pi / 2)) / 2
        }
        
        func bounceEaseOut(_ t: Float) -> Float {
            if (t < 4 / 11.0) {
                return (121 * t * t) / 16.0
            } else if (t < 8 / 11.0) {
                return (363 / 40.0 * t * t) - (99 / 10.0 * t) + 17 / 5.0
            } else if (t < 9/10.0) {
                return (4356 / 361.0 * t * t) - (35442 / 1805.0 * t) + 16061 / 1805.0
            }
            return (54 / 5.0 * t * t) - (513 / 25.0 * t) + 268 / 25.0
        }
    }
    
    func create(_ layer: CALayer, values: [Float], timeingFuntion: EaseFunction = .cubicOut, compltionBlock: (Bool) -> ()) {
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "position.x")
        keyframeAnimation.duration = 1
        keyframeAnimation.values = timeingFuntion.values(start: values[0], end: values[1], duration: 1)
        keyframeAnimation.delegate = self
        keyframeAnimation.repeatCount = 10
        layer.add(keyframeAnimation, forKey: "position.x")
    }
    
}

extension KeyframeAnimation: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag, let closure = compltionBlock {
            closure(flag)
        }
        print("animation end")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        print("animation start")
    }
    
}
