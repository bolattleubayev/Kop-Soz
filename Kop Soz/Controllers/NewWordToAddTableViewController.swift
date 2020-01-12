//
//  NewWordToAddTableViewController.swift
//  Kop Soz
//
//  Created by macbook on 12/31/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class NewWordToAddTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var wordCollections: AllCollections?
    var collectionIndex: Int?
    
    @IBOutlet weak var wordItselfTextField: UITextField! {
        didSet {
            wordItselfTextField.tag = 1
            wordItselfTextField.becomeFirstResponder()
            wordItselfTextField.delegate = self
        }
    }
    
    
    @IBOutlet weak var wordDescriptionTextView: UITextView! {
        didSet {
            wordDescriptionTextView.tag = 2
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if wordItselfTextField.text != "", wordDescriptionTextView.text != "" {
            
            wordCollections?.collections[collectionIndex!].words.append(AllCollections.WordCollection.WordInCollection(wordItself: wordItselfTextField.text!, wordDescription: wordDescriptionTextView.text))
            
            
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Упс...", message: "Кажется некоторые поля остались пусты", preferredStyle: .alert)
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
        
        // Configure Navigation Bar Appearance
        //navigationController?.navigationBar.tintColor = .white
        //navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }

}
