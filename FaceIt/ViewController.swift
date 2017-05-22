//
//  ViewController.swift
//  FaceIt
//
//  Created by Vito on 21/05/2017.
//  Copyright © 2017 Vito. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet { // gonna happen when ios hooks up to the view, only once
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
            updateUI()
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
























