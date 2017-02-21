//
//  APIUTILS.swift
//  AppGraffiti
//
//  Created by User on 11/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import Foundation
import UIKit

let CONSTANTES = Constantes()



struct Constantes {
    let COLORES = Colores()
    let CONEXIONES_URL = Base_Url()
}


struct Colores {
    let AZUL_BARRA_NAV = #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0.8352941176, alpha: 1)
    let BLANCO_TEXTO_BARRA_NAV = UIColor.white
}

struct Base_Url {
    let BASE_URL = "https://jsonplaceholder.typicode.com/photos"
    let BASE_URL_IMDB = "http://www.omdbapi.com/?s=Batman&page="
}
