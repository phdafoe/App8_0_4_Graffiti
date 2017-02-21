//
//  GraffitiModel.swift
//  AppGraffiti
//
//  Created by User on 18/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import MapKit

class GraffitiModel: NSObject, NSCoding {
    
    var direccionGrafiti : String?
    var latitudGrafiti : Double?
    var longitudGrafiti : Double?
    var imagenGrafiti : String? //almacenamos la url de la imagen
    
    
    init(pDireccionGrafiti : String, pLatitudGrafiti : Double, pLongitudGrafiti : Double, pImagenGrafiti : String) {
        //Nuestra propiedad es = al parametro del constructor
        self.direccionGrafiti = pDireccionGrafiti
        self.latitudGrafiti = pLatitudGrafiti
        self.longitudGrafiti = pLongitudGrafiti
        self.imagenGrafiti = pImagenGrafiti
        super.init()
    }
    
    //Codificamos las propiedades en claves definiendo s"String", d"Double"
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.direccionGrafiti, forKey : "sDireccionGrafiti")
        aCoder.encode(self.latitudGrafiti, forKey : "dLatitudGrafiti")
        aCoder.encode(self.longitudGrafiti, forKey : "dLongitudGrafiti")
        aCoder.encode(self.imagenGrafiti, forKey: "sImagenGrafiti")
    }
    
    
    //Requiere un inicializador de conveniencia opcional -> una vez que entras en ellos tienes que llamar al inicializadro principal
    //estamos decodigicando cada uno de los objetos que vamos a persisitir (codigicamos y decodifcamos)
    required convenience init?(coder aDecoder : NSCoder) {
        let direccionGrafiti = aDecoder.decodeObject(forKey : "sDireccionGrafiti") as! String
        let latitudGrafiti = aDecoder.decodeObject(forKey: "dLatitudGrafiti") as! Double
        let longitudGrafiti = aDecoder.decodeObject(forKey: "dLongitudGrafiti") as! Double
        let imagenGrafiti = aDecoder.decodeObject(forKey: "sImagenGrafiti") as! String
        
        self.init(pDireccionGrafiti : direccionGrafiti,
                  pLatitudGrafiti : latitudGrafiti,
                  pLongitudGrafiti : longitudGrafiti,
                  pImagenGrafiti : imagenGrafiti)
    }
    
    
}

//MARK: -> //Protocolo MKAnnotation
extension GraffitiModel : MKAnnotation{
    var coordinate : CLLocationCoordinate2D{
        get{
            return CLLocationCoordinate2D(latitude: latitudGrafiti!, longitude: longitudGrafiti!)
        }
    }
    
    var title : String?{
        get{
            return "Grafiti"
        }
    }
    
    var subtitle : String?{
        get{
            //le decimos que nos sustituya un "\n" por una ""
            return direccionGrafiti?.replacingOccurrences(of: "\n", with: "")
        }
    }

}










