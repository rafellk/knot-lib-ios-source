//
//  FeederViewController.swift
//  KnotTest
//
//  Created by aluno on 12/05/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import UIKit

class FeederViewController: UIViewController {

    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        durationLabel.text = "\(Util.duration ?? "") (ms)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func feedButtonPressed(_ sender: Any) {
        if let uuid = Util.idThing, let durationString = Util.duration, let duration = Int(durationString)  {
            KnotSocketIO().setData(thingUUID: uuid, sensorID: 3, value: duration) { (data, error) in
                guard error == nil else {
                    print("error: \(error!.localizedDescription)")
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                print("")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
