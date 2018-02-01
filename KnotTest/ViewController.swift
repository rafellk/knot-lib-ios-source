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
    private var socket: SocketIOClient!
    private var manager: SocketManager!
    private var datasource: [[String : Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Devices"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let socketIO = KnotSocketIO()
        
        socketIO.getDevices { (data, error) in
            guard error == nil else {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            self.datasource = data as? [[String : Any]]
            self.tableView.reloadData()
        }
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
        let cell = UITableViewCell()
        let row = indexPath.row
        cell.textLabel?.text = (datasource![row])["name"] as? String
        cell.detailTextLabel?.text = (datasource![row])["uuid"] as? String
        return cell
    }
}

