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
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    }
    
    var wordCollections: AllCollections?
    var collectionIndex: Int?
    private var currentWord = 0
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var wordLabel: UILabel! {
        didSet {
            if wordCollections?.collections[collectionIndex!].words.count != 0 {
                wordLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordItself
            }
        }
    }
    
    @IBOutlet weak var descriptionLabel: UITextView! {
        didSet {
            if wordCollections?.collections[collectionIndex!].words.count != 0 {
                descriptionLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordDescription
            }
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if currentWord != (wordCollections?.collections[collectionIndex!].words.count)! - 1 {
            currentWord += 1
            
            UIView.transition(
            with: cardView,
            duration: 0.6,
            options: [.transitionFlipFromLeft],
            animations: {
                self.wordLabel.text = self.wordCollections?.collections[self.collectionIndex!].words[self.currentWord].wordItself
                self.descriptionLabel.text = self.wordCollections?.collections[self.collectionIndex!].words[self.currentWord].wordDescription
            },
            completion: nil)
        }
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        if currentWord != 0 {
            currentWord -= 1
            UIView.transition(
            with: cardView,
            duration: 0.6,
            options: [.transitionFlipFromRight],
            animations: {
                self.wordLabel.text = self.wordCollections?.collections[self.collectionIndex!].words[self.currentWord].wordItself
                self.descriptionLabel.text = self.wordCollections?.collections[self.collectionIndex!].words[self.currentWord].wordDescription
            },
            completion: nil)
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
