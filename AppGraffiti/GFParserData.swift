//
//  GFParserData.swift
//  AppGraffiti
//
//  Created by User on 14/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import SwiftyJSON

class GFParserData: NSObject {
    
    func getNoticiasModel(dataFromNetworking : NSData) -> [GFNoticiasModel]{
        var arrayNoticiasModel = [GFNoticiasModel]()
        let readableJSON = JSON(data: dataFromNetworking as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
        for item in 0..<readableJSON.count{
            let noticiasModel = GFNoticiasModel(pAlbumId: readableJSON[item]["albumId"].int!,
                                                pId: readableJSON[item]["id"].int!,
                                                pTitle: readableJSON[item]["title"].string!,
                                                pUrl: readableJSON[item]["url"].string!,
                                                pThumbnailUrl: readableJSON[item]["thumbnailUrl"].string!)
            arrayNoticiasModel.append(noticiasModel)
        }
        return arrayNoticiasModel
    }
    
    

}
