//
//  LearnWordsViewController.swift
//  Kop Soz
//
//  Created by macbook on 1/7/20.
//  Copyright © 2020 bolattleubayev. All rights reserved.
//

import UIKit

class LearnWordsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var wordCollections: AllCollections?
    var collectionIndex: Int?
    private var currentWord = 0
    
    @IBOutlet weak var wordLabel: UILabel! {
        didSet {
            wordLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordItself
        }
    }
    
    @IBOutlet weak var descriptionLabel: UITextView! {
        didSet {
            descriptionLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordDescription
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if currentWord != (wordCollections?.collections[collectionIndex!].words.count)! - 1 {
            currentWord += 1
            wordLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordItself
            descriptionLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordDescription
        }
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        if currentWord != 0 {
            currentWord -= 1
            wordLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordItself
            descriptionLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordDescription
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
