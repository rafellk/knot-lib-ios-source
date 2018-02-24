//
//  SensorViewController.swift
//  KnotTest
//
//  Created by Rafael Lucena on 2/24/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation
import UIKit

class SensorViewController: UIViewController {
    
    // MARK: IBOutlets variables
    @IBOutlet weak var sensorStatusLabel: UILabel!
    @IBOutlet weak var sensorChangeSwitch: UISwitch!
    
    // MARK: Segue variables
    var selectedThingUUID: String?
    var sensorID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sensor ID: \(sensorID ?? "")"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        if let thingUUID = selectedThingUUID, let selectedSensorID = sensorID, let sensorID = Int(selectedSensorID) {
//            KnotSocketIO().getData(thingUUID: thingUUID, sensorID: sensorID, callback: { (data, error) in
//                guard error == nil else {
//                    print("error: \(error!.localizedDescription)")
//
//                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//                    alertController.addAction(action)
//                    self.present(alertController, animated: true, completion: nil)
//
//                    return
//                }
//
//                if let data = data {
//                    for result in data {
//                        if let getData = result["get_data"] as? [[String : Any]], let getData[0] {
//                        }
//                    }
//                }
//            })
//        }
        
        fetch()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            self.fetch()
        }
    }
    
    private func fetch() {
        if let uuid = self.selectedThingUUID {
            
            KnotHttp().data(uuid: uuid, callback: { (data, error) in
                guard error == nil else {
                    print("error: \(error!.localizedDescription)")
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                var result = ""
                
                if let data = data?.reversed() {
                    for value in data {
                        if let sensorData = value["data"] as? [String : Any], String(sensorData["sensor_id"] as! Int) == self.sensorID, let value = sensorData["value"] {
                            result = "\(value)"
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.sensorStatusLabel.text = result
                    self.sensorChangeSwitch.setOn(result == "1", animated: true)
                }
            })
        }
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        
    }
}
