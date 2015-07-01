//
//  InsetTextField.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 23..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

@IBDesignable
class InsetTextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , insetX , insetY)
    }
    
    // text position
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , insetX , insetY)
    }
}