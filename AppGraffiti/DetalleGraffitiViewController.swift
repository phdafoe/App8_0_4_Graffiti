//
//  DetalleGraffitiViewController.swift
//  AppGraffiti
//
//  Created by User on 11/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

class DetalleGraffitiViewController: UIViewController {
    
    
    
    @IBAction func cerraVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgNavBarTitle = UIImage(named: "img_navbar_title")
        self.navigationItem.titleView = UIImageView(image: imgNavBarTitle)

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
