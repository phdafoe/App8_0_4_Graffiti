//
//  DetalleGraffitiViewController.swift
//  AppGraffiti
//
//  Created by User on 11/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

protocol DetalleGraffitiViewControllerDelegate {
    // siempre en el metodo del delegado el viewController del que es el Protocolo (remitente) y le devolvemos el grafiti NO??
    func grafitiEtiquetado(_ detalleVC : DetalleGraffitiViewController, grafitiEtiquetado : GraffitiModel)
}


class DetalleGraffitiViewController: UIViewController {
    
    //MARK: - Variables
    var infoGrafiti : GraffitiModel?
    var grafitiDelegate : DetalleGraffitiViewControllerDelegate?
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var myPickerImageView: UIImageView!
    @IBOutlet weak var myLatitudLBL: UILabel!
    @IBOutlet weak var myLongitudLBL: UILabel!
    @IBOutlet weak var myDireccionLBL: UILabel!
    @IBOutlet weak var mySalvarDataBTN: UIBarButtonItem!
    
    
    //MARK: - IBActions
    @IBAction func cerraVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func salvarFotografiaDelGrafito(_ sender: Any) {
        //PASO 3 -> SINGLETON
        if let imageDes = myPickerImageView.image{
            //random name asi creamos un nombre aleatorio con un final en jpg
            let randomName = UUID().uuidString.appending(".png")
            //Aqui ontenemos toda la ruta url "y ademas" nuestra imagen
            if let url = APIManagerData.shared.imagesUrl()?.appendingPathComponent(randomName), let imageData = UIImagePNGRepresentation(imageDes){
                do{
                    try imageData.write(to: url)
                }catch let error{
                    print("Error salvando la imagen: \(error.localizedDescription)")
                }
            }
            
            //crear nuestro objeto
            infoGrafiti = GraffitiModel(pDireccionGrafiti: myDireccionLBL.text!,
                                        pLatitudGrafiti: Double(myLatitudLBL.text!)!,
                                        pLongitudGrafiti: Double(myLongitudLBL.text!)!,
                                        pImagenGrafiti: randomName)
            //Comprobamos si existe
            if let infoGrafitiDes = infoGrafiti{
                //LLamamos al delegado que implementa la funcion en esta VC
                grafitiDelegate?.grafitiEtiquetado(self, grafitiEtiquetado: infoGrafitiDes)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        myPickerImageView.isUserInteractionEnabled = true
        let tomaFotoGR = UITapGestureRecognizer(target: self, action: #selector(self.PickPhoto))
        myPickerImageView.addGestureRecognizer(tomaFotoGR)
        configuracionLabels()
        let imgNavBarTitle = UIImage(named: "img_navbar_title")
        self.navigationItem.titleView = UIImageView(image: imgNavBarTitle)

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configuracionLabels(){
        myLatitudLBL.text = String(format: "%.6f", (infoGrafiti?.coordinate.latitude)!)
        myLongitudLBL.text = String(format: "%.6f", (infoGrafiti?.coordinate.longitude)!)
        myDireccionLBL.text = infoGrafiti?.direccionGrafiti
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



//MARK: - PICKER PHOTO
extension DetalleGraffitiViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func PickPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            showPhotoMenu()
        }else{
            choosePhotoFromLIbrary()
        }
    }
    
    func showPhotoMenu(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAccion = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            Void in self.takePhotoWithCamera()
        })
        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default, handler: {
            Void in self.choosePhotoFromLIbrary()
        })
        alertController.addAction(cancelAccion)
        alertController.addAction(takePhotoAction)
        alertController.addAction(chooseFromLibraryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func takePhotoWithCamera(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func choosePhotoFromLIbrary(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageData = info[UIImagePickerControllerEditedImage] as? UIImage{
            myPickerImageView.image = imageData
            mySalvarDataBTN.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


