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
    private var datasource: [BaseDevice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Gateways"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                self.datasource = data
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
        
        cell!.textLabel?.text = (datasource![row]).type
        cell!.detailTextLabel?.text = (datasource![row]).uuid
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let datasource = datasource {
            let index = indexPath.row
            let device = datasource[index]
            
            if let uuid = device.uuid {
                performSegue(withIdentifier: "toDevices", sender: uuid)
            }
        }
    }
}
