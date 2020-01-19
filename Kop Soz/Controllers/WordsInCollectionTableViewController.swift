//
//  WordsInCollectionTableViewController.swift
//  Kop Soz
//
//  Created by macbook on 12/29/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class WordsInCollectionTableViewController: UITableViewController {
    
    var wordCollections: AllCollections?
    var collectionIndex: Int?
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var emptyWordView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
        navigationController?.hidesBarsOnSwipe = true
        
        
        // updating after popover
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        tableView.backgroundView = emptyWordView
        tableView.backgroundView?.isHidden = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        //navigationController?.navigationBar.tintColor = .black
        navigationItem.title = wordCollections?.collections[collectionIndex!].collectionName
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("Untitled.json") {
            if let jsonData = try? Data(contentsOf: url) {
                wordCollections = AllCollections(json: jsonData)!
            }
        }
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (wordCollections?.collections[collectionIndex!].words.count)! > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (wordCollections?.collections[collectionIndex!].words.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Celldom"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WordsInCollectionTableViewCell

        // Configure the cell...
        cell.wordNameLabel?.text = wordCollections?.collections[collectionIndex!].words[indexPath.row].wordItself
        cell.wordDescriptionText?.text = wordCollections?.collections[collectionIndex!].words[indexPath.row].wordDescription
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // Delete the row from the data source
            self.wordCollections?.collections[self.collectionIndex!].words.remove(at: indexPath.row)
            
            if let json = self.wordCollections?.json {
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
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        let swipeCinfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeCinfiguration
    }
    
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "AddNewWord" {
            let destinationController = segue.destination.contents as! NewWordToAddTableViewController
            destinationController.wordCollections = wordCollections
            destinationController.collectionIndex = collectionIndex
        } else if segue.identifier == "EditSectionName" {
            let destinationController = segue.destination.contents as! EditSectionNameTableViewController
            destinationController.wordCollections = wordCollections
            destinationController.collectionIndex = collectionIndex
            
        }
    }
    

}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}
