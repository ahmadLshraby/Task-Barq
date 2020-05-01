//
//  DetailedVC.swift
//  Task
//
//  Created by Ahmad Shraby on 5/1/20.
//  Copyright © 2020 sHiKoOo. All rights reserved.
//

import UIKit
import Kingfisher

class DetailedVC: UIViewController {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var linkBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    var selectedTitle: String?
    var selectedImage: String?
    var selectedURL: String?
    var selectedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        title = selectedTitle
        linkBtn.setTitle("Show video: \(selectedURL ?? "video link")", for: .normal)
        dateLbl.text = "Created at: \(selectedDate ?? "video date")"
        if let imagePath = selectedImage {
            let url = URL(string: imagePath)
            self.videoImage.kf.indicatorType = .activity
            self.videoImage.kf.setImage(with: url, placeholder: UIImage(named: "logo2"), options: [.transition(.fade(1))])
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @IBAction func linkBtn(_ sender: UIButton) {
        shouldPresentAlertView(true, title: "Video Link", alertText: selectedURL, actionTitle: "Go", errorView: nil)
    }
    
}
