//
//  ViewController.swift
//  FaceIt
//
//  Created by Vito on 21/05/2017.
//  Copyright © 2017 Vito. All rights reserved.
//

import UIKit

class FaceViewController: VCLLoggingViewController {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet { // gonna happen when ios hooks up to the view, only once
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
//            tapRecognizer.numberOfTapsRequired = 1
//            faceView.addGestureRecognizer(tapRecognizer)
            
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increasseHappiness))
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)
            updateUI()
        }
    }
    
    private struct HeadShake {
        static let angle = CGFloat.pi/6 // radians
        static let segmentDuration: TimeInterval = 0.5 //each head shake has 3 segments
    }
    
    private func rotateFace(by angle: CGFloat) {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private func shakeHead() {
        UIView.animate(
            withDuration: HeadShake.segmentDuration,
            animations: { self.rotateFace(by: HeadShake.angle) }, // we're in middle of animation, no need to break mem cycle
            completion: { finished in
                if finished {
                    UIView.animate(
                        withDuration: HeadShake.segmentDuration,
                        animations: { self.rotateFace(by: -HeadShake.angle*2) },
                        completion: { finished in
                            if finished {
                                UIView.animate(
                                    withDuration: HeadShake.segmentDuration,
                                    animations: { self.rotateFace(by: HeadShake.angle) }
                                )
                            }
                    }
                        
                        
                    )
                }
                
        })
    }
    
    @IBAction func shakeHead(_ sender: Any) {
        shakeHead()
    }
    
    func increasseHappiness()
    {
        expression = expression.happier
    }
    
    func decreaseHappiness()
    {
        expression = expression.sadder
    }
    
    func toggleEyes(byReactingTo tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    var expression = FacialExpression(eyes: .closed, mouth: .frown) {
        didSet { // when we initialize something, didSet doesn't get called.
            updateUI()
        }
    }
    
    /// Makes the model match the UI
    private func updateUI()
    {
        switch expression.eyes {
        case .open:
            // ? in case updateUI gets called before view is set up. We use optional chaining so if faceView is nil, the rest is ignored
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0 // if can't find the expression, default to neutral curvature
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.grin: 0.5, .frown:-1.0, .smile: 1.0, .neutral: 0.0, .smirk: -0.5]
    
    
    
}
























