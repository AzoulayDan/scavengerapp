//
//  InitialViewController.swift
//  scavengerapp
//
//  Created by student on 08/11/2017.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit
import CoreLocation
import Dispatch

class InitialViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var miBeaconsButton: UIButton!
    var locationManager : CLLocationManager!
    var end_detection = false
    
    override func viewDidLoad() {   //Passage d'abord dans cette fonction
        super.viewDidLoad()
        self.title = "Home"
        self.miBeaconsButton.isEnabled = false
        self.miBeaconsButton.backgroundColor = UIColor.lightGray
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedWhenInUse){
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    scanning() //Debut de la detection des beacons à l'aide de la fonction scanning
                }
            }
        }
    }
    
    func scanning (){
        //let uuid_beacons_mission = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let uuid_beacons_mission = UUID(uuidString: "deadbeef-1ee7-cafe-babe-c0ffee0ff1ce")!
        let region = CLBeaconRegion(proximityUUID: uuid_beacons_mission, major: 1, minor: 1, identifier: "")
        region.notifyOnExit = true
        region.notifyOnEntry = true
        region.notifyEntryStateOnDisplay = true
        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(in: region) //Provoque un callback à la reception des données.
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if (beacons.count > 0){
            if (beacons[0].proximity == .immediate || beacons[0].proximity == .near || beacons[0].proximity == .far){
                print("hello man, je suis assez proche du beacons pour choisir ce que je veux. Mettre cela dans le cas réel du test bordel de chiot de merde")
            }
            else {
                self.miBeaconsButton.isEnabled = true
                self.miBeaconsButton.backgroundColor = UIColor.white
                locationManager.stopMonitoring(for: region)
                locationManager.stopRangingBeacons(in: region)
            }
        }
    }
    
    @IBAction func onPressed_miBeacons_button(_ sender: UIButton) {
        //let inscriptionVC = InscriptionViewController(nibName: "InscriptionViewController", bundle: nil)
        //self.navigationController?.pushViewController(inscriptionVC, animated: true)
        account_exist()
    }
    
    func account_exist(){
        struct AccountExistRequest:Codable{
            let identifier_device:String
        }
        
        let unique_identifier = UIDevice.current.identifierForVendor!.description
        let data = AccountExistRequest(identifier_device: "putain") //Normalement l'identifiant unique
        
        let url = URL(string:"https://scavengergame.herokuapp.com/game/connect")!
        var url_request = URLRequest(url: url)
        url_request.httpMethod = "POST"
        url_request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        url_request.addValue("application/json", forHTTPHeaderField: "Accept")
        url_request.httpBody = try! JSONEncoder().encode(data)
        URLSession.shared.dataTask(with: url_request, completionHandler: handler_account_exist).resume()
    }
    
    func handler_account_exist(dataMaybe: Data?, urlResponse: URLResponse?, error: Error?){
        //Structure identique à la réponse du serveur
        struct AccountExistResponse : Codable {
            let exist: Int
        }
        
        guard let data = try? JSONDecoder().decode(AccountExistResponse.self, from: dataMaybe!) else {
            print("Reponse du serveur n'est pas celle attendue")
            return
        }
        
        print(data)
        
        //La réponse du serveur est conforme a ce qui est attendu
        if (data.exist == 400){
            let alert = UIAlertController(title: "Bad request", message: "Error during the send of the data to the server", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        //L'appareil existe
        if (data.exist == 1){
            let missionVC = MissionViewController(nibName: "MissionViewController", bundle: nil)
            self.navigationController?.pushViewController(missionVC, animated: true)
        }
        
        //L'appareil n'existe pas
        if (data.exist == 0){
            let inscriptionVC = InscriptionViewController(nibName: "InscriptionViewController", bundle: nil)
            self.navigationController?.pushViewController(inscriptionVC, animated: true)
        }
    }
    
}
