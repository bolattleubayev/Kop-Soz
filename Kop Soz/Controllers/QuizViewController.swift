//
//  QuizViewController.swift
//  Kop Soz
//
//  Created by macbook on 1/7/20.
//  Copyright © 2020 bolattleubayev. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    //MARK: - Global Variables and Constants
    
    let defaults = UserDefaults.standard
    var wordCollections: AllCollections?
    var collectionIndex: Int?
    private var currentWord = 0
    private var sessionQuizScore = 0
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if wordCollections?.collections[collectionIndex!].words.count == 0 {
            if defaults.integer(forKey: "language") == 0 {
                wordLabel.text = "Сөздер жоқ"
            } else if defaults.integer(forKey: "language") == 1 {
                wordLabel.text = "Нет слов"
            } else {
                wordLabel.text = "No words"
            }
        }
    }
    
    //MARK: - Outlets and Actions
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var wordLabel: UILabel! {
        didSet {
            if wordCollections?.collections[collectionIndex!].words.count != 0 {
                wordLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordItself
            }
        }
    }
    
    @IBOutlet weak var aButton: UIButton!
    
    @IBOutlet weak var bButton: UIButton!
    
    @IBOutlet weak var cButton: UIButton!
    
    @IBOutlet weak var dButton: UIButton!
    
    
    @IBAction func aButtonPressed(_ sender: UIButton) {
        
        flipCardForwardForQuiz()
    }
    
    @IBAction func bButtonPressed(_ sender: UIButton) {
        
        flipCardForwardForQuiz()
    }
    
    @IBAction func cButtonPressed(_ sender: UIButton) {
        
        flipCardForwardForQuiz()
    }
    
    @IBAction func dButtonPressed(_ sender: UIButton) {
        
        flipCardForwardForQuiz()
    }
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        flipCardForwardForQuiz()
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        flipCardBackwardForQuiz()
    }
    
    
    
    // MARK: - Functions
    
    private func flipCardForwardForQuiz() {
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
        } else if currentWord == (wordCollections?.collections[collectionIndex!].words.count)! - 1{
            currentWord = 0
            
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
    
    private func flipCardBackwardForQuiz() {
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
        } else if currentWord == 0, (wordCollections?.collections[collectionIndex!].words.count)! != 0 {
            currentWord = (wordCollections?.collections[collectionIndex!].words.count)! - 1
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
