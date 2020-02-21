//
//  LearnWordsTableViewController.swift
//  Kop Soz
//
//  Created by macbook on 1/7/20.
//  Copyright © 2020 bolattleubayev. All rights reserved.
//

import UIKit

class LearnWordsTableViewController: UITableViewController {
    
    var wordCollections = AllCollections()
    let defaults = UserDefaults.standard
    var animatedCellIndecies = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8014437556, blue: 0.004643389955, alpha: 1)]
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.8014437556, blue: 0.004643389955, alpha: 1)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Prepare the empty view
        tableView.backgroundView = emptyLearnView
        tableView.backgroundView?.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaults.integer(forKey: "language") == 0 {
            self.title = "Оқу"
            navigationItem.title = "Оқу"
        } else if defaults.integer(forKey: "language") == 1 {
            self.title = "Учить"
            navigationItem.title = "Учить"
        } else {
            self.title = "Learn"
            navigationItem.title = "Learn"
        }
        
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
    
    @IBOutlet var emptyLearnView: UIView!
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if wordCollections.collections.count > 0 {
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
        return wordCollections.collections.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LearnCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CollectionsTableViewCell
        
        // Configure the cell...
        
        cell.collectionNameTextField.text = wordCollections.collections[indexPath.row].collectionName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //MARK: Slide-in, Fade-in effect
        if !animatedCellIndecies.contains(indexPath.row) {
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
            cell.alpha = 0
            
            UIView.animate(
                withDuration: 0.7,
                delay: 0.05 * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
            })
            
            animatedCellIndecies.append(indexPath.row)
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "GoToSection" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! LearnWordsViewController
                destinationController.wordCollections = wordCollections
                destinationController.collectionIndex = indexPath.row
                //destinationController.wordDescriptions = wordsInCollectionDescriptions[indexPath.row]
            }
        } 
    }
}
