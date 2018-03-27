//
//  ViewController.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/19/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import UIKit
import SocketIO

class SensorsViewController: UIViewController {
    
    // MARK: IBOutlets Variables
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Segue Variables
    var selectedUUID: String?
    
    // MARK: Pooling Variables
    private var timer: Timer?
    
    // MARK: Variables
    private var datasource: [String : Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sensors"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
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
        if let uuid = self.selectedUUID {
            
            KnotHttp().data(deviceUUID: uuid, callback: { (data, error) in
                guard error == nil else {
                    print("error: \(error!.localizedDescription)")
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                var results = [String : Any]()
                
                if let data = data?.reversed() {
                    for value in data {
                        if let sensorID = value.sensorData?.sensorID, let value = value.sensorData?.value {
                            results["\(sensorID)"] = value
                        }
                    }
                }
                
                self.datasource = results
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SensorViewController
        let params = sender as! (String, String)
        
        destination.selectedThingUUID = params.0
        destination.sensorID = params.1
    }
}

extension SensorsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let datasource = datasource {
            return datasource.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell")!
        let row = indexPath.row
        
        if let datasource = datasource {
            let sensorID = Array(datasource.keys)[row]
            
            cell.textLabel?.text = "sensor id: \(sensorID)"
            cell.detailTextLabel?.text = "value: \(datasource[sensorID] as! Bool)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let datasource = datasource {
            let row = indexPath.row
            let sensorID = Array(datasource.keys)[row]
            
            performSegue(withIdentifier: "toSensor", sender: (selectedUUID, sensorID))
        }
    }
}

