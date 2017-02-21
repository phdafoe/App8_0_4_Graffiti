//
//  APIHELPERS.swift
//  AppGraffiti
//
//  Created by User on 18/2/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import Foundation
import UIKit

func muestraAlerta(_ titleData : String, messageData : String, titleMessageData : String) -> UIAlertController{
    let alert = UIAlertController(title: titleData, message: messageData, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: titleMessageData, style: .default, handler: nil))
    return alert
    }
