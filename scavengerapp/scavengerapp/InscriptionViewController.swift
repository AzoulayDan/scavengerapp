//
//  InscriptionViewController.swift
//  scavengerapp
//
//  Created by student on 09/11/2017.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class InscriptionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mTextField_login: UITextField!
    @IBOutlet weak var mTextField_password: UITextField!
    
    let login_placeholder = "The name of your team"
    let password_placeholder = "The password to access at your account"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Registration"
        self.navigationItem.hidesBackButton = true
        self.initialize_textfields_view()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Initialisation des textfields */
    internal func initialize_textfields_view () {
        self.mTextField_login.placeholder = login_placeholder
        self.mTextField_password.placeholder = password_placeholder
        self.mTextField_password.isSecureTextEntry = true
    }
    
    /* Remise à 0 des textfields */
    internal func reset_textfields_view () {
        TextFieldManager.reset_textfields(textfields: [self.mTextField_login, self.mTextField_password])
        self.initialize_textfields_view()
    }
    
    /* Implémentation du delegate */
    /* Quand l'écriture sur le textfield commence (quand il devient actif) */
    /*func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("coucou")
        if (TextFieldManager.isEmpty_textfield(textfield: textField) == true) {
            textField.placeholder = ""
        }
        return true
     }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("je suis la")
        if (TextFieldManager.isEmpty_textfield(textfield: textField) == true){
            
            if (textField.placeholder! == login_placeholder){
                textField.placeholder = ""
            }
        }
     }
   
    /* Qaund l'écriture est en cours dans un textfield */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.text!.characters.count + (string.characters.count))
        if ((textField.text!.characters.count + (string.characters.count)) >= 4){
            textField.resignFirstResponder()
            return false
        }
        return true;
    }
    
    /* Quand l'écriture est terminé */
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.mTextField_login.resignFirstResponder()
        self.mTextField_password.resignFirstResponder()
        return true;
    }
 */
    
    /* Action effectué au click sur le bouton "To register" */
    @IBAction func onPressed_mRegisterButtoon(_ sender: UIButton) {
        let all_not_empty:Bool = TextFieldManager.isEmpty_textfields(textfields: [self.mTextField_login, self.mTextField_password])
        
        print(all_not_empty)
        
        //Un ou la totalité des textfield sont vides.
        if (all_not_empty == true){
            let is_empty_login:Bool = TextFieldManager.isEmpty_textfield(textfield: self.mTextField_login)
            let is_empty_password:Bool = TextFieldManager.isEmpty_textfield(textfield: self.mTextField_password)
            
            if (is_empty_login == true && is_empty_password == true){
                self.display_alert(title: "All empty", message: "All fields must be filled to validate your registration")
            }
            else if (is_empty_login == true && is_empty_password == false){
                self.display_alert(title: "Login empty", message: "Login field must be filled to validate your registration")
            }
            else if (is_empty_login == false && is_empty_password == true){
                self.display_alert(title: "Password empty", message: "Password field must be filled to validate your registration")
            }
        }
        else if (all_not_empty == false){
            self.create_account()
        }
    }
    
    /* Cette fonction effectue une requête pour créer un nouveau compte utilisateur */
    internal func create_account(){
        self.mTextField_password.resignFirstResponder()
        self.mTextField_login.resignFirstResponder()
        //Declaration de la structure de données a envoyer
        struct AccountCreationRequest:Codable {
            let login:String
            let password:String
            let identifier:String
        }
        
        let device = UIDevice.current.identifierForVendor!.description
        let login = self.mTextField_login.text!
        let password = self.mTextField_password.text!
        print(password)
        print(login)
        
        //A envoyer le vrai device
        let datas_to_send = AccountCreationRequest(login: login, password: password, identifier: "babar3")
        let datas =  try! JSONEncoder().encode(datas_to_send)
        
        let url = URL(string:"https://scavengergame.herokuapp.com/game/team/create_account")!
        var url_request = URLRequest(url: url)
        url_request.httpMethod = "POST"
        url_request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        url_request.addValue("application/json", forHTTPHeaderField: "Accept")
        url_request.httpBody = datas
        URLSession.shared.dataTask(with: url_request, completionHandler: handlerAccountCreation).resume()
    }
    
    func handlerAccountCreation(dataMaybe: Data?, urlResponse: URLResponse?, error: Error?) {
        //Strucuture de données renvoyée par le serveur
        struct AccountCreationResponse:Codable {
            let creation_game_account:Int
        }
        
        guard let data = try? JSONDecoder().decode(AccountCreationResponse.self, from:dataMaybe!) else {
            print("Reponse du serveur n'est pas celle attendue")
            return
        }
        
        print(data)
        
        if (data.creation_game_account == 400){
            self.display_alert(title: "Bad request", message: "An error occured during the send datas at the server")
        }
        
        if (data.creation_game_account == 409){
            self.display_alert(title: "Name already exists", message: "The name for your team is not available. You must choice another name, sorry!")
        }
        
        if (data.creation_game_account == 201){
            self.display_alert_created(title: "Account created", message: "Your account created")
        }
    }
    
    /* Cette fonction permet d'afficher une alerte avec un message custom */
    internal func display_alert(title:String?, message:String?){
        let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /* Cette fonction permet d'afficher une alerte avec un message custom ainsi que l'affichage d'un VC */
    internal func display_alert_created(title:String?, message:String?){
        let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            let missionVC = MissionViewController(nibName: "MissionViewController", bundle: nil)
            self.navigationController?.pushViewController(missionVC, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
