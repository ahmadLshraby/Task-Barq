//
//  VideosServises.swift
//  Task
//
//  Created by Ahmad Shraby on 5/1/20.
//  Copyright © 2020 sHiKoOo. All rights reserved.
//

import Foundation
import Alamofire


class VideosServices {
    static let instance = VideosServices()
    
    var videosData = [Videos]()
    var msg: String?
    
    // Get Types
    func getVideos(handler: @escaping(_ success: Bool) -> Void) {
        
        Alamofire.request(videosURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.result.error == nil {
                print(response)
                
                do {
                    let responseData = try JSONDecoder().decode(VideosModel.self, from: response.data!)
                    
                    // Check the response status code
                    if responseData.error == false {
                        // Cast the optional data
                        guard let videos = responseData.videos else { return }
                        self.videosData = videos
                        
                        handler(true)
                    }else {
                        guard let msg = responseData.message else { return }
                        self.msg = msg
                        
                        print(msg)
                        handler(true)
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
            } else {
                debugPrint(response.result.error as Any)
                if let errorMsg = response.result.error?.localizedDescription {
                    self.msg = errorMsg
                }else {
                    self.msg = "Please, Check Your Internet Connection"
                }
                handler(false)
            }
        }
    }
    
    
    
    
    
}
