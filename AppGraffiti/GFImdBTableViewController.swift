//
//  GFImdBTableViewController.swift
//  AppGraffiti
//
//  Created by User on 21/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import PromiseKit
import Kingfisher

class GFImdBTableViewController: UITableViewController {
    
    var id = "1"
    var arrayDatosImdb : [GFdcComicsModel] = []
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var extraButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        llamadaIMdB()
        
        
        if revealViewController() != nil {
            //revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            extraButton.target = revealViewController()
            extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.register(UINib(nibName: "GFDatosIMdbCell", bundle: nil), forCellReuseIdentifier: "DatosIMdbCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayDatosImdb.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "DatosIMdbCell", for: indexPath) as! GFDatosIMdbCell
        
        let datosModel = arrayDatosImdb[indexPath.row]
        print("\(datosModel.poster!)")
        
        customCell.myImagenIMdB.kf.setImage(with: URL(string: datosModel.poster!),
                                                           placeholder: #imageLiteral(resourceName: "placehoder"),
                                                           options: nil,
                                                           progressBlock: nil,
                                                           completionHandler: nil)
        
        customCell.myTituloIMdB.text = datosModel.title
        customCell.myIdIMdB.text = datosModel.imdbID
        customCell.myAñoIMdB.text = datosModel.year
        customCell.myTipoIMdB.text = datosModel.type
        
        return customCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    

    func llamadaIMdB(){
        let datosImdB = GFParserIMDBEjemplo()
        firstly{
            return when(resolved: datosImdB.getDatosImdb(id: id))
            }.then{_ in
                self.arrayDatosImdb = datosImdB.parserImdb()
            }.then{_ in
                self.tableView.reloadData()
            }.catch{ error in
                self.present(muestraAlerta("", messageData: "", titleMessageData: ""), animated: true, completion: nil)
            }
        }

}
