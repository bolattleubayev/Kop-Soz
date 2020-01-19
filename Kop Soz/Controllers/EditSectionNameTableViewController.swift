//
//  EditSectionNameTableViewController.swift
//  Kop Soz
//
//  Created by macbook on 1/19/20.
//  Copyright © 2020 bolattleubayev. All rights reserved.
//

import UIKit

class EditSectionNameTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var wordCollections: AllCollections?
    var collectionIndex: Int?
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var sectionRenameLabel: UILabel!
    
    @IBOutlet weak var editedSectionNameTextField: UITextField! {
        didSet {
            editedSectionNameTextField.delegate = self
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if editedSectionNameTextField.text != "" {
            print("index: \(collectionIndex) \n text:\(editedSectionNameTextField.text!)")
            wordCollections!.collections[collectionIndex!].collectionName = editedSectionNameTextField.text!
            
            if let json = wordCollections?.json {
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
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.integer(forKey: "language") == 0 {
            sectionRenameLabel.text = "Секция атын өзгерту"
        } else if defaults.integer(forKey: "language") == 1 {
            sectionRenameLabel.text = "Переименовать секцию"
        } else {
            sectionRenameLabel.text = "Rename section"
        }
    }
}
