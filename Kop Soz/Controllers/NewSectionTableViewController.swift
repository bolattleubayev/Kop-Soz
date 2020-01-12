//
//  NewSectionTableViewController.swift
//  Kop Soz
//
//  Created by macbook on 12/31/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class NewSectionTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var wordCollections: AllCollections?
    
    @IBOutlet weak var sectionNameTextField: UITextField! {
        didSet {
            sectionNameTextField.delegate = self
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if sectionNameTextField.text != "" {
            
            wordCollections!.collections.append(AllCollections.WordCollection(collectionName: sectionNameTextField.text!, words: []))
            
            if let json = wordCollections?.json {
                        // printing json data
            //            if let jsonString = String(data: json, encoding: .utf8) {
            //                print(jsonString)
            //            }
                        
                        // writing data to the disc, document directory
                        if let url = try? FileManager.default.url(
                            for: .documentDirectory,
                            in: .userDomainMask,
                            appropriateFor: nil,
                            create: true
                            ).appendingPathComponent("Untitled.json"){
                            do {
                                try json.write(to: url)
                                print ("saved successfully")
                            } catch let error {
                                print ("couldn't save \(error)")
                            }
                        }
                    }
            
            // notification to updtate table view before dismiss
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSections"), object: nil)
            
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Упс...", message: "Кажется Вы не написали название секции", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    }


}
