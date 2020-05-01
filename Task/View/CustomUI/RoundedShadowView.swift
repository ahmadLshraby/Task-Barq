//
//  RoundedView.swift
//  VOOOM
//
//  Created by Ahmad Shraby on 3/26/19.
//  Copyright © 2019 Cloud4Rain. All rights reserved.
//

import UIKit


@IBDesignable
class RoundedShadowView: UIView {
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
  
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        
        self.layer.shadowOffset = shadowOffset     // direction to down
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = #colorLiteral(red: 0.1490196078, green: 0.1725490196, blue: 0.3960784314, alpha: 1)
    }
    
}
