//
//  SmartFeederSettingsViewController.swift
//  KnotTest
//
//  Created by aluno on 12/05/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import UIKit

class SmartFeederSettingsViewController: UIViewController {

    @IBOutlet weak var durationInputText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        durationInputText.text = Util.duration
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConfirmPressed(_ sender: Any) {
        if let duration = durationInputText.text {
            Util.duration = duration
        }
        
        navigationController?.popViewController(animated: true)
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
