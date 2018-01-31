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

    private var socket: SocketIOClient!
    private var manager: SocketManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        let socketIO = KnotSocketIO()
        
        socketIO.getDevices { (data, error) in
            guard error == nil else {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            print(data!)
        }
    }
}

