//
//  SettingsTableViewController.swift
//  Kop Soz
//
//  Created by macbook on 1/20/20.
//  Copyright © 2020 bolattleubayev. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var languageSegmentedControlOutlet: UISegmentedControl!
    
    
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        defaults.set(languageSegmentedControlOutlet.selectedSegmentIndex, forKey: "language")
    }
    
}
