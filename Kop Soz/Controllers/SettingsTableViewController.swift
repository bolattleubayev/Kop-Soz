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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)]
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        languageSegmentedControlOutlet.selectedSegmentIndex = defaults.integer(forKey: "language")
        changeLabelsLanguage()
    }
    
    private func changeLabelsLanguage() {
        if defaults.integer(forKey: "language") == 0 {
            navigationItem.title = "Теңшеулер"
            contactsLabel.text = "Контакттар"
            languageLabel.text = "Тіл"
        } else if defaults.integer(forKey: "language") == 1 {
            navigationItem.title = "Наcтройки"
            contactsLabel.text = "Контакты"
            languageLabel.text = "Язык"
        } else {
            navigationItem.title = "Settings"
            contactsLabel.text = "Contact us"
            languageLabel.text = "Language"
        }
    }
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var contactsLabel: UILabel!
    
    @IBOutlet weak var languageSegmentedControlOutlet: UISegmentedControl! {
        didSet {
            languageSegmentedControlOutlet.selectedSegmentIndex = defaults.integer(forKey: "language")
            NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
            changeLabelsLanguage()
        }
    }
    
    
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        defaults.set(languageSegmentedControlOutlet.selectedSegmentIndex, forKey: "language")
        NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
        changeLabelsLanguage()
    }
    
}
