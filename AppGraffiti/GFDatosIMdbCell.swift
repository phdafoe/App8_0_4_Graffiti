//
//  GFDatosIMdbCell.swift
//  AppGraffiti
//
//  Created by User on 21/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

class GFDatosIMdbCell: UITableViewCell {
    
    
    @IBOutlet weak var myImagenIMdB: UIImageView!
    @IBOutlet weak var myTituloIMdB: UILabel!
    @IBOutlet weak var myAñoIMdB: UILabel!
    @IBOutlet weak var myIdIMdB: UILabel!
    @IBOutlet weak var myTipoIMdB: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
