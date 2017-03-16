//
//  APIManagerData.swift
//  AppGraffiti
//
//  Created by User on 14/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

class APIManagerData: NSObject {
    
    //SINGLETON
    static let shared = APIManagerData()
    
    
    var grafitisData : [GraffitiModel] = []
    
    
    func salvarDatos(){
        //URL en donde vamos a guardar nuestro archivo
        if let url = dataBaseURL(){
            NSKeyedArchiver.archiveRootObject(grafitisData, toFile: url.path)
        }else{
            print("Error guardando datos")
        }
    }
    
    
    func cargarDatos(){
        //Comprobamos la url y ademas (,)
        if let url = dataBaseURL(), let datosSalvados = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? [GraffitiModel]{
           //aqui ya tendriamos nuestros datos cargados en grafitis
            grafitisData = datosSalvados
        }else{
            print("Error cargando los datos")
        }
    }
    
    //Queremos la carpeta en donde guardar las imagenes
    func imagesUrl() -> URL?{
        if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
            let url = URL(fileURLWithPath: documentDirectory)
            return url
        }else{
            return nil
        }
    }
    
    //aqui guardamos el archivo con nuestra informacion del tipo Grafiti
    func dataBaseURL() -> URL? {
        //debemos comprobar si existe nuestro directorio "Documents"
        if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
            let url = URL(fileURLWithPath: documentDirectory)
            return url.appendingPathComponent("grafitis.data")
        }else{
            return nil
        }
    }
    
    
    
    
        
    
    
    
    
    
    
    
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
