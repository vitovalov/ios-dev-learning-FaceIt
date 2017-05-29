//
//  FaceView.swift
//  FaceIt
//
//  Created by Vito on 21/05/2017.
//  Copyright © 2017 Vito. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable // to be inspectable, we need to always specify the type
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var eyesOpen: Bool = true { didSet {
        leftEye.eyesOpen = eyesOpen
        rightEye.eyesOpen = eyesOpen
        //        setNeedsDisplay()
        } }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet {
        leftEye.lineWidth = lineWidth
        rightEye.lineWidth = lineWidth
        
        setNeedsDisplay()
        } }
    
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet {
        leftEye.color = color
        rightEye.color = color
        setNeedsDisplay()
        } }
    
    @IBInspectable
    var mouthCurvature: Double = 0.5 { didSet { setNeedsDisplay() } } // 1.0 is full smile and -1.0 is full frown
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            print("scale= \(scale)")
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    // by making it calculated property, we can recompute it every time bounds change
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    // two possible centers:
    //        let skullCenter = convert(center, from:superview)
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye
    {
        case left
        case right
    }
    
    
    // we define it here because only be used here inside
    private func centerOfEye(_ eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
        return eyeCenter
    }
    
    private lazy var leftEye: EyeView = self.createEye() // can't call createEye since property inits run before self is available. We can set it lazy so that it gets called once the class is fully initialized. With lazy vars we need to explicit type. We want to create eyes on the instance, not static, so use self.
    private lazy var rightEye: EyeView = self.createEye()
    
    private func createEye() -> EyeView {
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = color
        eye.lineWidth = lineWidth
        self.addSubview(eye)
        
        return eye
    }
    
    private func positionEye(_ eye: EyeView, center: CGPoint) {
        let size = skullRadius / Ratios.skullRadiusToEyeRadius * 2 // to make diameter
        eye.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        eye.center = center
    }
    
    // In VC we have viewDidLayout method to know when bounds changes. If we are a view, we are told when size of the view bounds changes here. Is sent to all subviews when the view bounds changes or anytime when they need to be relayed out
    override func layoutSubviews() {
        super.layoutSubviews()
        positionEye(leftEye, center: centerOfEye(.left))
        positionEye(rightEye, center: centerOfEye(.right))
    }
    
    //    private func pathForEye(_ eye: Eye) -> UIBezierPath {
    //
    //
    //        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
    //        let eyeCenter = centerOfEye(eye)
    //
    //        // can be initialized only once
    //        let path: UIBezierPath
    //        if (eyesOpen) {
    //            // conditionally initializing it
    //            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
    //        } else {
    //            path = UIBezierPath()
    //            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
    //            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
    //        }
    //
    //        path.lineWidth = lineWidth
    //
    //        return path
    //    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2,
                               y: skullCenter.y + mouthOffset,
                               width: mouthWidth,
                               height: mouthHeight
        )
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)
        
        //let path = UIBezierPath(rect: mouthRect)
        let path = UIBezierPath()
        
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        path.lineWidth = lineWidth
        
        return path
    }
    
    private func pathForSkull() -> UIBezierPath
    {
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        
        color.set()
        pathForSkull().stroke()
        //        pathForEye(.left).stroke()
        //        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }
    
    // this is how we write constants
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }
}
