//
//  RoundedButton.swift
//  VOOOM
//
//  Created by Ahmad Shraby on 4/1/19.
//  Copyright © 2019 Cloud4Rain. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    var originalSize: CGRect?   // to track the button status
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: CGColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1) {
        didSet {
            self.layer.borderColor = borderColor
        }
    }
    
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
    
    
}
