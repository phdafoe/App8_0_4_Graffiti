//
//  CurrentLocationViewController.swift
//  AppGraffiti
//
//  Created by User on 11/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    
    
    //MARK: - Variables locales
    var myGrafiti : GraffitiModel?
    let locationManager = CLLocationManager()
    //determinaremos que mientras sea false haga algo y que cuando cambie a verdadera haga algo distinto
    var actualizandoLocalizacion = false {
        //que se ha hecho
        didSet{
            if actualizandoLocalizacion{
                self.buscaMapa.setImage(#imageLiteral(resourceName: "btn_localizar_off"), for: .normal)
                self.myActivitiIndicator.isHidden = false
                self.myActivitiIndicator.startAnimating()
                self.buscaMapa.isUserInteractionEnabled = false
            }else{
                self.buscaMapa.setImage(#imageLiteral(resourceName: "btn_localizar_on"), for: .normal)
                self.myActivitiIndicator.isHidden = true
                self.myActivitiIndicator.stopAnimating()
                self.buscaMapa.isUserInteractionEnabled = true
            }
        }
    }
    
    var calloutImagenSeleccionada : UIImage?
    
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var buscaMapa: UIButton!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var myAñadirButton: UIBarButtonItem!
    @IBOutlet weak var myActivitiIndicator: UIActivityIndicatorView!
    
    
    //MARK: - IBACTIONS
    
    @IBAction func obtenerLocalizacion(_ sender: Any) {
        iniciaLocationManager()
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //PASO 1 -> SINGLETON -> Llamamos nuestro singleton y cargamos los grafitis
        APIManagerData.shared.cargarDatos()

        //siempre tenemos nuestro boton de mapa en falso
        actualizandoLocalizacion = false
        
        
        if revealViewController() != nil {
            //revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            //extraButton.target = revealViewController()
            //extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let imgNavBarTitle = UIImage(named: "img_navbar_title")
        self.navigationItem.titleView = UIImageView(image: imgNavBarTitle)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myMapView.delegate = self
        myMapView.addAnnotations(APIManagerData.shared.grafitisData)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Utils
    func iniciaLocationManager(){
        //Saber el estado de autorizacion por parte del usuario al locationManager
        let estadoAutorizacion = CLLocationManager.authorizationStatus()
        switch estadoAutorizacion {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            present(muestraAlerta("Localización desactivada",
                                  messageData: "Por favor, activa la lozalización para esta Aplicacion en los ajustes del dispositivo",
                                  titleMessageData: "OK"),
                    animated: true,
                    completion: nil)
            self.myAñadirButton.isEnabled = false
        default:
            if CLLocationManager.locationServicesEnabled(){
                self.actualizandoLocalizacion = true
                self.myAñadirButton.isEnabled = false
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
                
                //Realizamos zoom sobre la localizacion del usuario
                //determinamos las coordenadas del usuario(dispositivo)
                //1000 -> 1 Km
                let region = MKCoordinateRegionMakeWithDistance(myMapView.userLocation.coordinate, 1000, 1000)
                //myMapView.setRegion(region, animated: true)
                myMapView.setRegion(myMapView.regionThatFits(region), animated: true)
                
                
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagGraffiti"{
            let navControler = segue.destination as! UINavigationController
            let detaVC = navControler.topViewController as! DetalleGraffitiViewController
            detaVC.infoGrafiti = myGrafiti
            // por que nos hacemos delegados una vez que tenga la foto nos lo tiene que devolver para que lo gravemos y pongamos el pinAnotation
            detaVC.grafitiDelegate = self
        
        }
        
        //PASO INFO DE LA VC DE CURRENT A IMAGE DETALLE
        if segue.identifier == "showPinImage"{
            let navVC = segue.destination as! UINavigationController
            let detalleImageVC = navVC.topViewController as! ImagenGrafitiViewController
            detalleImageVC.calloutSleccionadaData = calloutImagenSeleccionada
        }
        
    }
    
    


}

extension CurrentLocationViewController : CLLocationManagerDelegate{
    
    //Tratamos errores
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("***** Error en Core Location *****")
    }
    
    //Cambio en la localizacion hacemos algo
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Comprobamos una nueva localizacion
        /*guard let nuevaLocalizacion = locations.last else {
            return
        }*/
        
        if let userLocation = locations.last{
            let latitud = Double(userLocation.coordinate.latitude)
            let longitud = Double(userLocation.coordinate.longitude)
            
            //geocodificacion inversa
            CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if error == nil{
                    var direccion = ""
                    if let placemarkData = placemarks?.last{
                        direccion = self.stringFromPlacemark(placemarkData)
                    }
                    self.myGrafiti = GraffitiModel(pDireccionGrafiti: direccion,
                                                   pLatitudGrafiti: latitud,
                                                   pLongitudGrafiti: longitud,
                                                   pImagenGrafiti: "")
                }
                self.actualizandoLocalizacion = false
                self.myAñadirButton.isEnabled = true
            }
        }
    }
    
    func stringFromPlacemark(_ placemark : CLPlacemark) -> String{
        var lineaUno = ""
        if let string = placemark.thoroughfare{
            lineaUno += string + ", "
        }
        if let string = placemark.subThoroughfare{
            lineaUno += string
        }
        var lineaDos = ""
        if let string = placemark.postalCode{
            lineaDos += string + " "
        }
        if let string = placemark.locality{
            lineaDos += string
        }
        var lineaTres = ""
        if let string = placemark.administrativeArea{
            lineaTres += string + " "
        }
        if let string = placemark.country{
            lineaTres += string
        }
        return lineaUno + "\n" + lineaDos + "\n" + lineaTres
    }
    
    
    
    
}



extension CurrentLocationViewController : DetalleGraffitiViewControllerDelegate{
    
    //Nuestro protolo de la vista Detalle
    func grafitiEtiquetado(_ detalleVC: DetalleGraffitiViewController, grafitiEtiquetado: GraffitiModel) {
        //PASO 2 -> SINGLETON
        APIManagerData.shared.grafitisData.append(grafitiEtiquetado)
        APIManagerData.shared.salvarDatos() 
    }
    
    
}


//FASE FINAL DESPUES DEL SINGLETON -> Pintar pines personalizados
extension CurrentLocationViewController : MKMapViewDelegate{
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        
        //Pasa algo muy perecido como a las celdas de las tablas / se reaprovechan los pines que has salido de la pantalla para los que vienen ahora
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "grafitiPin")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "grafitiPin")
        }else{
            annotationView?.annotation = annotation
        }
        
        
        //Vamos a configurar la anotacion
        if let place = annotation as? GraffitiModel{
            //Hacemos referencia a las diferentes piezas de nuestro objeto
            let imageName = place.imagenGrafiti
            //debemos comprobar la imagen 
            if let imagesUrl = APIManagerData.shared.imagesUrl(){
                do{
                    let imageData = try Data(contentsOf: imagesUrl.appendingPathComponent(imageName!))
                    self.calloutImagenSeleccionada = UIImage(data: imageData)
                    let image = resizeImage(calloutImagenSeleccionada!, newWidth: 40.0) // aqui imagen
                    let btnImageView = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40)) // boton
                    btnImageView.setImage(image, for: .normal)
                    annotationView?.leftCalloutAccessoryView = btnImageView
                    
                    annotationView?.image = #imageLiteral(resourceName: "img_pin") //le enchufamos la imagen
                    annotationView?.canShowCallout = true // le decimos que muestre los datos
                }catch let error{
                    print("Error en la configuracion de la imagen: \(error.localizedDescription)")
                }
            }
        }
        return annotationView
    }
    
    //Cuando le damos tap al boton
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView{
            performSegue(withIdentifier: "showPinImage", sender: view)
        }
    }
    
    
    
    
    func resizeImage(_ image : UIImage, newWidth : CGFloat) -> UIImage{
        let scale = newWidth / image.size.width
        let newHeigth = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeigth))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeigth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext() // tendriamos la imagen creada
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    
    
    
    
    
}




