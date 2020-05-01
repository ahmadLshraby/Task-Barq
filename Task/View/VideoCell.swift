//
//  VideoCell.swift
//  Task
//
//  Created by Ahmad Shraby on 5/1/20.
//  Copyright © 2020 sHiKoOo. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(video: Videos) {
        self.titleLbl.text = video.title
        
        if let imagePath = video.thumb {
            let url = URL(string: imagePath)
            self.videoImage.kf.indicatorType = .activity
            self.videoImage.kf.setImage(with: url, placeholder: UIImage(named: "logo2"), options: [.transition(.fade(1))])
        }
        
        
    }
    
}
