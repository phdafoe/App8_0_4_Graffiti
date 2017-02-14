//
//  GFNoticiasModel.swift
//  AppGraffiti
//
//  Created by User on 14/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

class GFNoticiasModel: NSObject {

    var albumId : Int?
    var id : Int?
    var title : String?
    var url : String?
    var thumbnailUrl : String?
    
    
    init(pAlbumId : Int, pId : Int, pTitle : String, pUrl : String, pThumbnailUrl : String) {
        
        self.albumId = pAlbumId
        self.id = pId
        self.title = pTitle
        self.url = pUrl
        self.thumbnailUrl = pThumbnailUrl
        
        super.init()
        
    }

}
