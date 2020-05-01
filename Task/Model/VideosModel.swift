//
//  VideosModel.swift
//  Task
//
//  Created by Ahmad Shraby on 5/1/20.
//  Copyright © 2020 sHiKoOo. All rights reserved.
//

import Foundation


struct VideosModel : Codable {
    let error : Bool?
    let message : String?
    let videos : [Videos]?
}


struct Videos : Codable {
    let id : Int?
    let url : String?
    let vimeo_id : String?
    let thumb : String?
    let created_at : String?
    let updated_at : String?
    let category_id : Int?
    let home_workout : Int?
    let is_send_notification : String?
    let is_featured : String?
    let archived : String?
    let is_free : String?
    let keywordword : String?
    let type : String?
    let is_nutrition : Int?
    let created_by : Int?
    let video_id : Int?
    let lang : String?
    let lang_code : String?
    let title : String?
    let description : String?
}
