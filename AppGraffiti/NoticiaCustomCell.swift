//
//  NoticiaCustomCell.swift
//  AppGraffiti
//
//  Created by User on 14/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

class NoticiaCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var myImagenPost: UIImageView!
    @IBOutlet weak var myTituloPost: UILabel!
    @IBOutlet weak var myMiniaturaPost: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
