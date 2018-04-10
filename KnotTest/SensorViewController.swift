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
    
    // MARK: Pooling Variables
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sensor ID: \(sensorID ?? "")"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.fetch()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    private func fetch() {
        if let uuid = self.selectedThingUUID {
            
            KnotHttp().data(deviceUUID: uuid, callback: { (data, error) in
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
                        if let value = value.sensorData?.value {
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
        // todo: implement this
    }
}
