//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Vito on 22/05/2017.
//  Copyright © 2017 Vito. All rights reserved.
//

import Foundation

struct FacialExpression
{
    enum Eyes: Int {
        case open
        case closed
        case squinting
    }
    
    enum Mouth: Int/* Int is the raw-value type*/ {
        case frown
        case smirk
        case neutral
        case grin
        case smile
        
        var sadder: Mouth {
            // return previous case if exist, or frown
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        
        var happier: Mouth {
            // return next case if exist, or smile
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    
    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
    
    // properties of this struct
    let eyes: Eyes
    let mouth: Mouth
}






