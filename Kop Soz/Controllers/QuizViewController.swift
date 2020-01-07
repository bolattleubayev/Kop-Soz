//
//  QuizViewController.swift
//  Kop Soz
//
//  Created by macbook on 1/7/20.
//  Copyright © 2020 bolattleubayev. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    var wordCollections: AllCollections?
    var collectionIndex: Int?
    private var currentWord = 0
    
    @IBOutlet weak var wordLabel: UILabel! {
        didSet {
            wordLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordItself
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if currentWord != (wordCollections?.collections[collectionIndex!].words.count)! - 1 {
            currentWord += 1
            wordLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordItself
        }
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        if currentWord != 0 {
            currentWord -= 1
            wordLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordItself
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDefinition" {
            let destinationController = segue.destination as! QuizDescriptionViewController
            
            destinationController.wordDescriptionText = wordCollections?.collections[collectionIndex!].words[currentWord].wordDescription
        }
    }

}
