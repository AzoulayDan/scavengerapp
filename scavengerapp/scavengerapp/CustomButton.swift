//
//  CustomButton.swift
//  scavengerapp
//
//  Created by student on 08/11/2017.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    @IBInspectable var border_width: CGFloat = 0.0
    @IBInspectable var border_raduis: CGFloat = 0.0
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = border_width
        self.layer.cornerRadius = border_raduis

    }

}
