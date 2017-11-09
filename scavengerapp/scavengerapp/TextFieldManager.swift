//
//  TextFieldManager.swift
//  scavengerapp
//
//  Created by student on 09/11/2017.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class TextFieldManager: NSObject {
    /*
     Cette fonction permet de verifier que l'ensemble des textfields sont remplis.
     */
    static func isEmpty_textfields (textfields:[UITextField]) -> Bool {
        var empty : Bool = false
        
        for aTextfield in textfields {
            let text_tf : String = aTextfield.text!
            if ((text_tf as NSString).length == 0) {
                empty = true
            }
        }
        return empty
    }
    
    /*
     Cette fonction permet de vérifier qu'un textfield est rempli.
     */
    static func isEmpty_textfield (textfield:UITextField) -> Bool {
        let text_tf : String = textfield.text!
        
        if ((text_tf as NSString).length == 0) {
            return true
        }
        return false
    }
    
    /*
     Cette méthode permet d'effectuer un reset de l'ensemble des textfields.
     */
    static func reset_textfields (textfields:[UITextField]) ->Void {
        for atextfield in textfields {
            atextfield.text = ""
        }
    }
}
