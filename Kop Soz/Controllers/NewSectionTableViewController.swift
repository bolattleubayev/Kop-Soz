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
    
    @IBOutlet weak var sectionImage: UIImageView!
    
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
            
            print(wordCollections)
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Oops", message: "We can't proceed because section name is missing", preferredStyle: .alert)
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
    }

    // MARK: - Table view data source

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            sectionImage.image = selectedImage
            sectionImage.contentMode = .scaleAspectFill
            sectionImage.clipsToBounds = true
        }
        
        let leadingConstraint = NSLayoutConstraint(item: sectionImage, attribute: .leading, relatedBy: .equal, toItem: sectionImage.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: sectionImage, attribute: .trailing, relatedBy: .equal, toItem: sectionImage.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: sectionImage, attribute: .top, relatedBy: .equal, toItem: sectionImage.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: sectionImage, attribute: .bottom, relatedBy: .equal, toItem: sectionImage.superview, attribute: .bottom, multiplier: 1, constant: 0)
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
