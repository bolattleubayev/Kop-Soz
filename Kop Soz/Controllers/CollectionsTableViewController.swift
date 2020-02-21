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
    let defaults = UserDefaults.standard
    private var animatedCellIndecies = [Int]()
    private var addingSection = false
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addSection(_ sender: UIButton) {
        addingSection = true
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    @IBOutlet var emptyCollectionView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8014437556, blue: 0.004643389955, alpha: 1)]
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.8014437556, blue: 0.004643389955, alpha: 1)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadSections), name: NSNotification.Name(rawValue: "loadSections"), object: nil)
        
        // Prepare the empty view
        tableView.backgroundView = emptyCollectionView
        tableView.backgroundView?.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaults.integer(forKey: "language") == 0 {
            self.title = "Қосу"
            navigationItem.title = "Секциялар"
        } else if defaults.integer(forKey: "language") == 1 {
            self.title = "Добавить"
            navigationItem.title = "Секции"
        } else {
            self.title = "Add"
            navigationItem.title = "Sections"
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
    }
    
    private func saver() {
        if let json = wordCollections.json {
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // If text field changes update values of the model
        
        for indexRow in 1..<tableView.visibleCells.count {
            if let cellText = (tableView.visibleCells[indexRow] as! CollectionsTableViewCell).collectionNameTextField.text {
                wordCollections.collections[indexRow-1].collectionName = cellText
            }
            
        }
        
        saver()
    }
    
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: return 1
        case 1: return wordCollections.collections.count
        default: return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CollectionsTableViewCell
            
            // Configure the cell...
            
            cell.collectionNameTextField?.text = wordCollections.collections[indexPath.row].collectionName
            cell.collectionNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            
            return cell
        } else if addingSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddingCell", for: indexPath)
            if let inputCell = cell as? CollectionsTableViewCell {
                inputCell.collectionNameTextField.becomeFirstResponder()
                inputCell.resignationHandler = { [weak self, unowned inputCell] in //breaking the memory cycle
                    
                    if let text = inputCell.collectionNameTextField.text {
                        self?.wordCollections.collections.insert(AllCollections.WordCollection.init(collectionName: "", words: []), at: 0)
                        // Add row
                        tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                        self?.wordCollections.collections[indexPath.row].collectionName = text
                    }
                        
                    
                    
                    self?.saver()
                    
                    self?.addingSection = false
                    self?.tableView.reloadData() // updating data because model have changed
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddSectionTableViewCell
            
            var buttonTitle = ""
            
            if defaults.integer(forKey: "language") == 0 {
                buttonTitle = "+ Қосу"
            } else if defaults.integer(forKey: "language") == 1 {
                buttonTitle = "+ Добавить"
            } else {
                buttonTitle = "+ Add"
            }
            
            cell.addButton.setTitle(buttonTitle, for: .normal)
            
            return cell
        }
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
            
            self.saver()
            
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //MARK: Slide-in, Fade-in effect
        if indexPath.section == 1 {
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
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            saver()

            performSegue(withIdentifier: "showWordsInCollection", sender: self)
        }
    }
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
        } 
    }
    

}
