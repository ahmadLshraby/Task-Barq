//
//  RoundedImageView.swift
//  VOOOM
//
//  Created by Ahmad Shraby on 4/3/19.
//  Copyright © 2019 Cloud4Rain. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: CGColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            self.layer.borderColor = borderColor
        }
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2   // as the view is square
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.clipsToBounds = true
    }
    
}
