//
//  CollectionsTableViewController.swift
//  Kop Soz
//
//  Created by macbook on 12/29/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class CollectionsTableViewController: UITableViewController {
    
    var wordCollections = AllCollections()
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationController?.navigationBar.prefersLargeTitles = true
        NotificationCenter.default.addObserver(self, selector: #selector(loadSections), name: NSNotification.Name(rawValue: "loadSections"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    }
    @objc func loadSections(notification: NSNotification){
        //load data here
        print("table reloaded")
        
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wordCollections.collections.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CollectionsTableViewCell
        
        // Configure the cell...
        
        cell.collectionNameLabel?.text = wordCollections.collections[indexPath.row].collectionName
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // Delete the row from the data source
            self.wordCollections.collections.remove(at: indexPath.row)
            
            if let json = self.wordCollections.json {
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
        
        if segue.identifier == "showWordsInCollection" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! WordsInCollectionTableViewController
                destinationController.wordCollections = wordCollections
                destinationController.collectionIndex = indexPath.row
                //destinationController.wordDescriptions = wordsInCollectionDescriptions[indexPath.row]
            }
        } else if segue.identifier == "AddNewSection" {
            let destinationController = segue.destination.contents as! NewSectionTableViewController
            destinationController.wordCollections = wordCollections
        }
    }
    

}
