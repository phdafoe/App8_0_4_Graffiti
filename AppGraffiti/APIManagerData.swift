//
//  APIManagerData.swift
//  AppGraffiti
//
//  Created by User on 14/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

class APIManagerData: NSObject {
    
    static let shared = APIManagerData()
    
    
    //MARK: - Variables locales
    let noticias = GFParserData()
    
    
    
    //MARK: - GET USERS
    func getNoticiasApi() -> [GFNoticiasModel]{
        let url = URL(string: CONSTANTES.CONEXIONES_URL.BASE_URL)
        let jsonData = NSData(contentsOf: url!)
        let arrayUsersModel = noticias.getNoticiasModel(dataFromNetworking: jsonData!)
        return arrayUsersModel
    }
    
    

}
