//
//  UIViewControllerSpinnerExt.swift
//  VOOOM
//
//  Created by Ahmad Shraby on 4/16/19.
//  Copyright © 2019 Cloud4Rain. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func shouldPresentLoadingView(_ status: Bool) {
        var fadeView: UIView?
        
        if status == true {
            fadeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            fadeView?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1725490196, blue: 0.3960784314, alpha: 1)
            fadeView?.alpha = 0.0
            fadeView?.tag = 99
            
            let spinner = UIActivityIndicatorView()
            spinner.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            spinner.style = .whiteLarge
            spinner.center = view.center
            
            view.addSubview(fadeView!)
            fadeView?.addSubview(spinner)
            
            spinner.startAnimating()
            
            fadeView?.fadeTo(alphaValue: 0.7, withDuration: 0.2)
        }else {
            for subview in view.subviews {
                if subview.tag == 99 {
                    UIView.animate(withDuration: 0.2, animations: {
                        subview.alpha = 0.0
                    }) { (finished) in
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    
    
    
    func shouldPresentAlertView(_ status: Bool, title: String?, alertText: String?, actionTitle: String?, errorView: UIView?) {
        var fadeView: UIView?
        
        if status == true {
            fadeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            fadeView?.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1725490196, blue: 0.3960784314, alpha: 1)
            fadeView?.alpha = 0.0
            fadeView?.tag = 100
            
            let alert = UIAlertController(title: title, message: alertText, preferredStyle: .alert)
            let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] action in
                self?.shouldPresentAlertView(false, title: nil, alertText: nil, actionTitle: nil, errorView: nil)
                errorView?.shake()
                
//                errorView?.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//                errorView?.layer.borderWidth = 2.0
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            view.addSubview(fadeView!)
            
            fadeView?.fadeTo(alphaValue: 0.7, withDuration: 0.2)
        }else {
            for subview in view.subviews {
                if subview.tag == 100 {
                    UIView.animate(withDuration: 0.2, animations: {
                        subview.alpha = 0.0
                    }) { (finished) in
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    
}
