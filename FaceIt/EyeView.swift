//
//  EyeView.swift
//  FaceIt
//
//  Created by Vito on 29/05/2017.
//  Copyright © 2017 Vito. All rights reserved.
//

import UIKit

class EyeView: UIView {

    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() }}
    
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay()}}
    
    var _eyesOpen: Bool = true { didSet { setNeedsDisplay() }} // private
    
    var eyesOpen: Bool { // only animate in case someone publicly sets my eyes open
        get {
            return _eyesOpen
        }
        
        set {
            if newValue != _eyesOpen {
                UIView.transition(with: self, duration: 0.4, options: [.transitionFlipFromTop], animations: {
                    self._eyesOpen = newValue
                })
            }
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        var path: UIBezierPath
        
        if eyesOpen {
            path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2))
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.minX, y:bounds.midY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        }
        
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }

}
