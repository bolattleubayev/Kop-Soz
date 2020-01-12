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
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
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
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if currentWord != (wordCollections?.collections[collectionIndex!].words.count)! - 1, (wordCollections?.collections[collectionIndex!].words.count)! != 0 {
            currentWord += 1
            UIView.transition(
            with: cardView,
            duration: 0.6,
            options: [.transitionFlipFromLeft],
            animations: {
                self.wordLabel.text = self.wordCollections?.collections[self.collectionIndex!].words[self.currentWord].wordItself
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
            },
            completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDefinition", (wordCollections?.collections[collectionIndex!].words.count)! > 0 {
            let destinationController = segue.destination as! QuizDescriptionViewController
            
            destinationController.wordDescriptionText = wordCollections?.collections[collectionIndex!].words[currentWord].wordDescription
        }
    }

}
