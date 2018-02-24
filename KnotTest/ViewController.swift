//
//  ViewController.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/19/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {

    // MARK: IBOutlets Variables
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    private var datasource: [[String : Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Gateways"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let http = KnotHttp()
        http.myDevices { (data, error) in
            guard error == nil else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)

                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)

                return
            }
            
            if let data = data {
                var gateways = [[String : Any]]()
                
                for result in data {
                    if let error = result["error"] as? [String : Any] {
                        print("An error occurred: \(error)")
                        
                        if let message = error["message"] as? String {
                            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                            
                            return
                        }
                        
                        return
                    }
                    
                    var gateway = [String : Any]()
                    
                    gateway["uuid"] = result["uuid"]
                    gateway["type"] = result["type"]
                    gateway["owner"] = result["uuid"]
                    gateway["online"] = result["online"]
                    
                    gateways.append(gateway)
                }
                
                self.datasource = gateways
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! DevicesViewController
        viewController.selectedGatewayUUID = sender as? String
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let datasource = datasource {
            return datasource.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell")
        let row = indexPath.row
        
        cell!.textLabel?.text = (datasource![row])["type"] as? String
        cell!.detailTextLabel?.text = (datasource![row])["uuid"] as? String
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let datasource = datasource {
            let index = indexPath.row
            let device = datasource[index]
            
            if let uuid = device["uuid"] as? String {
                performSegue(withIdentifier: "toDevices", sender: uuid)
            }
        }
    }
}
