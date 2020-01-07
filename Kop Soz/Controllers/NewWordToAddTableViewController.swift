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
    
    @IBOutlet weak var wordPhoto: UIImageView!
    
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
            let alert = UIAlertController(title: "Oops", message: "We can't proceed because some of the fields are blank", preferredStyle: .alert)
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
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    // MARK: - Table view data source
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            wordPhoto.image = selectedImage
            wordPhoto.contentMode = .scaleAspectFill
            wordPhoto.clipsToBounds = true
        }
        
        let leadingConstraint = NSLayoutConstraint(item: wordPhoto, attribute: .leading, relatedBy: .equal, toItem: wordPhoto.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: wordPhoto, attribute: .trailing, relatedBy: .equal, toItem: wordPhoto.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: wordPhoto, attribute: .top, relatedBy: .equal, toItem: wordPhoto.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: wordPhoto, attribute: .bottom, relatedBy: .equal, toItem: wordPhoto.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let photoSourceRequestController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                (action) in
                
                // you need to modify privacy reason in Info.plist to be able to request media data NSPhotoLibraryUsageDescription and NSCameraUsageDescription
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) { // checking if media type is available as user may restrict access
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: {
                (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) { // checking if media type is available as user may restrict access
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            present(photoSourceRequestController, animated: true, completion: nil)
            
        }
        
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
