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
    var animatedCellIndecies = [Int]()
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var emptyCollectionView: UIView!
    
    
    @IBAction func addNewSectionButtonTapped(_ sender: UIBarButtonItem) {
        // Create new collection
        wordCollections.collections.insert(AllCollections.WordCollection.init(collectionName: "", words: []), at: 0)
        // Add row
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        // Become first respoonder
        if let newCellTextField = (tableView.visibleCells[0] as! CollectionsTableViewCell).collectionNameTextField {
            newCellTextField.becomeFirstResponder()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8014437556, blue: 0.004643389955, alpha: 1)]
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.8014437556, blue: 0.004643389955, alpha: 1)
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
        for indexRow in 0..<tableView.visibleCells.count {
            
            if let cellText = (tableView.visibleCells[indexRow] as! CollectionsTableViewCell).collectionNameTextField.text {
                wordCollections.collections[indexRow].collectionName = cellText
            }
        }
        
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
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CollectionsTableViewCell
        
        // Configure the cell...
        
        cell.collectionNameTextField?.text = wordCollections.collections[indexPath.row].collectionName
        
        cell.collectionNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            
//            //MARK: Fade-in effect
//            // Define the initial state (Before the animation)
//            cell.alpha = 0
//
//            // Define the final state (After the animation)
//            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(indexPath.row), animations: { cell.alpha = 1 })
            
//            //MARK: Rotation effect
//            // Define the initial state (Before the animation)
//            let rotationAngleInRadians = 90.0 * CGFloat(Double.pi / 180.0)
//            let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
//
//            cell.layer.transform = rotationTransform
//
//            // Define the final state (After the animation)
//        UIView.animate(withDuration: 1.0, delay: 0.05 * Double(indexPath.row),animations: { cell.layer.transform = CATransform3DIdentity })
            
//            //MARK: Fly-in effect
//            // Define the initial state (Before the animation)
//
//            if !animatedCellIndecies.contains(indexPath.row) {
//                let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -200, 100, 0)
//
//                cell.layer.transform = rotationTransform
//
//                // Define the final state (After the animation)
//                UIView.animate(withDuration: 1.0, delay: 0.05 * Double(indexPath.row), animations: { cell.layer.transform = CATransform3DIdentity })
//
//                animatedCellIndecies.append(indexPath.row)
//            }
            
        //MARK: Slide-in effect
        if !animatedCellIndecies.contains(indexPath.row) {
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

            UIView.animate(
                withDuration: 0.7,
                delay: 0.05 * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
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
