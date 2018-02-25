//
//  ViewController.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/19/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import UIKit
import SocketIO

class DevicesViewController: UIViewController {
    
    // MARK: IBOutlets Variables
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Segue Variables
    var selectedGatewayUUID: String?
    
    // MARK: Variables
    private var datasource: [BaseThingDevice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Things"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let socketIO = KnotSocketIO()
        
        socketIO.getDevices { (data, error) in
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.datasource = data
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SensorsViewController
        destination.selectedUUID = sender as? String
    }
}

extension DevicesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let datasource = datasource {
            return datasource.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell")
        let row = indexPath.row
        
        cell!.textLabel?.text = (datasource![row]).name
        cell!.detailTextLabel?.text = (datasource![row]).uuid
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let datasource = datasource {
            let index = indexPath.row
            let device = datasource[index]
            
            if let uuid = device.uuid {
                performSegue(withIdentifier: "toSensors", sender: uuid)
            }
        }
    }
}
