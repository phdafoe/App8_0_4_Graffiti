//
//  GFParserIMDBEjemplo.swift
//  AppGraffiti
//
//  Created by User on 21/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import Alamofire

var jsonDataImdb : JSON?

class GFParserIMDBEjemplo: NSObject {
    
    
    
    func getDatosImdb(id : String)->Promise<JSON>{
        let request = NSMutableURLRequest(url: URL(string: CONSTANTES.CONEXIONES_URL.BASE_URL_IMDB + id)!)
        return Alamofire.request(request as URLRequest).responseJSON().then { (data) -> JSON in
            jsonDataImdb = JSON(data)
            return jsonDataImdb!
        }
    }
    
    
    func parserImdb() -> [GFdcComicsModel]{
        var arrayDatosImdb = [GFdcComicsModel]()
        for item in jsonDataImdb!["Search"]{
            let datosModel = GFdcComicsModel(pTitle: dimeString(item.1, nombre: "Title"),
                                             pYear: dimeString(item.1, nombre: "Year"),
                                             pImdbID: dimeString(item.1, nombre: "imdbID"),
                                             pType: dimeString(item.1, nombre: "Type"),
                                             pPoster: dimeString(item.1, nombre: "Poster"))
            arrayDatosImdb.append(datosModel)
        }
        return arrayDatosImdb
    }
}
