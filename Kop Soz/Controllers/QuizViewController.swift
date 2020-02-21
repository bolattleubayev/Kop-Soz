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
    
    // model
    let defaults = UserDefaults.standard
    var wordCollections: AllCollections?
    var collectionIndex: Int?
    private var currentWord = 0
    
    // Score tracking
    private var correctScore = 0
    private var wrongScore = 0
    
    // Game logic
    private var wordsArray = [String]()
    private var wordOptions = [String]()
    private var correctAnswerIndex: Int?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
        
        // Collecting all words in one array to use for options
        if let indexOfCollection = collectionIndex {
            if let collection = wordCollections?.collections[indexOfCollection] {
                for word in collection.words {
                    wordsArray.append(word.wordItself)
                }
            }
        }
        
        renameButtonLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if wordCollections?.collections[collectionIndex!].words.count == 0 {
            if defaults.integer(forKey: "language") == 0 {
                wordLabel.text = "Сөздер жоқ"
                correctPointsLabel.text = "Дұрыс"
                wrongPointsLabel.text = "Дұрыс емес"
            } else if defaults.integer(forKey: "language") == 1 {
                wordLabel.text = "Нет слов"
                correctPointsLabel.text = "Правильно"
                wrongPointsLabel.text = "Неравильно"
            } else {
                wordLabel.text = "No words"
                correctPointsLabel.text = "Correct"
                wrongPointsLabel.text = "Wrong"
            }
        }
        
        renameButtonLabels()
    }
    
    //MARK: - Outlets and Actions
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var wordLabel: UILabel! {
        didSet {
            if wordCollections?.collections[collectionIndex!].words.count != 0 {
                wordLabel.text = wordCollections?.collections[collectionIndex!].words[currentWord].wordDescription
            }
        }
    }
    
    @IBOutlet weak var correctPointsLabel: UILabel!
    
    @IBOutlet weak var wrongPointsLabel: UILabel!
    
    @IBOutlet weak var aButton: UIButton!
    
    @IBOutlet weak var bButton: UIButton!
    
    @IBOutlet weak var cButton: UIButton!
    
    @IBOutlet weak var dButton: UIButton!
    
    
    @IBAction func aButtonPressed(_ sender: UIButton) {
        
        buttonAnimator(buttonUsed: aButton)
        flipCardForwardForQuiz()
    }
    
    @IBAction func bButtonPressed(_ sender: UIButton) {
        
        buttonAnimator(buttonUsed: bButton)
        flipCardForwardForQuiz()
    }
    
    @IBAction func cButtonPressed(_ sender: UIButton) {
        
        buttonAnimator(buttonUsed: cButton)
        flipCardForwardForQuiz()
    }
    
    @IBAction func dButtonPressed(_ sender: UIButton) {
        
        buttonAnimator(buttonUsed: dButton)
        flipCardForwardForQuiz()
    }
    
    // MARK: - Functions
    
    private func buttonAnimator(buttonUsed: UIButton) {
        
        let buttonsArray = [aButton, bButton, cButton, dButton]
        
        if let correctAnswer = correctAnswerIndex {
            if correctAnswer == buttonsArray.firstIndex(of: buttonUsed) {
                
                correctScore += 1
                
                if defaults.integer(forKey: "language") == 0 {
                    correctPointsLabel.text = "Дұрыс: \(correctScore)"
                } else if defaults.integer(forKey: "language") == 1 {
                    correctPointsLabel.text = "Правильно: \(correctScore)"
                } else {
                    correctPointsLabel.text = "Correct: \(correctScore)"
                }
                
                buttonUsed.layer.backgroundColor = #colorLiteral(red: 0, green: 0.319541961, blue: 0.6728987098, alpha: 1)
                
                UIView.animate(withDuration: 0.4) {
                    buttonUsed.layer.backgroundColor =  #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                }
                
                UIView.animate(withDuration: 0.3) {
                    buttonUsed.layer.backgroundColor =  #colorLiteral(red: 0, green: 0.319541961, blue: 0.6728987098, alpha: 1)
                }
                
            } else {
                
                wrongScore += 1
                
                if defaults.integer(forKey: "language") == 0 {
                    wrongPointsLabel.text = "Дұрыс емес: \(wrongScore)"
                } else if defaults.integer(forKey: "language") == 1 {
                    wrongPointsLabel.text = "Неравильно: \(wrongScore)"
                } else {
                    wrongPointsLabel.text = "Wrong: \(wrongScore)"
                }
                
                buttonUsed.layer.backgroundColor = #colorLiteral(red: 0, green: 0.319541961, blue: 0.6728987098, alpha: 1)
                
                UIView.animate(withDuration: 0.4) {
                    buttonUsed.layer.backgroundColor =  #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                }
                
                UIView.animate(withDuration: 0.3) {
                    buttonUsed.layer.backgroundColor =  #colorLiteral(red: 0, green: 0.319541961, blue: 0.6728987098, alpha: 1)
                }
            }
        }
    }
    
    private func flipCardForwardForQuiz() {
        if currentWord != (wordCollections?.collections[collectionIndex!].words.count)! - 1, (wordCollections?.collections[collectionIndex!].words.count)! != 0 {
            currentWord += 1
            UIView.transition(
            with: cardView,
            duration: 0.6,
            options: [.transitionFlipFromLeft],
            animations: {
                self.wordLabel.text = self.wordCollections?.collections[self.collectionIndex!].words[self.currentWord].wordDescription
            },
            completion: nil)
        } else if currentWord == (wordCollections?.collections[collectionIndex!].words.count)! - 1{
            currentWord = 0
            
            UIView.transition(
            with: cardView,
            duration: 0.6,
            options: [.transitionFlipFromLeft],
            animations: {
                self.wordLabel.text = self.wordCollections?.collections[self.collectionIndex!].words[self.currentWord].wordDescription
            },
            completion: nil)
        }
        
        renameButtonLabels()
    }
    
    private func flipCardBackwardForQuiz() {
        if currentWord != 0 {
            currentWord -= 1
            UIView.transition(
            with: cardView,
            duration: 0.6,
            options: [.transitionFlipFromRight],
            animations: {
                self.wordLabel.text = self.wordCollections?.collections[self.collectionIndex!].words[self.currentWord].wordDescription
            },
            completion: nil)
        } else if currentWord == 0, (wordCollections?.collections[collectionIndex!].words.count)! != 0 {
            currentWord = (wordCollections?.collections[collectionIndex!].words.count)! - 1
            UIView.transition(
            with: cardView,
            duration: 0.6,
            options: [.transitionFlipFromRight],
            animations: {
                self.wordLabel.text = self.wordCollections?.collections[self.collectionIndex!].words[self.currentWord].wordDescription
            },
            completion: nil)
        }
        
        renameButtonLabels()
    }
    
    private func renameButtonLabels() {
        
        // Allocate options on button titles
        let buttonsArray = [aButton, bButton, cButton, dButton]
        
        if wordsArray.count == 0 {
            // If no words in section
            for button in buttonsArray {
                if let button = button {
                    
                    if defaults.integer(forKey: "language") == 0 {
                        button.setTitle("сөз жоқ", for: .normal)
                    } else if defaults.integer(forKey: "language") == 1 {
                        wordLabel.text = "нет слов"
                    } else {
                        wordLabel.text = "no words"
                    }
                    
                }
            }
            
        } else if wordsArray.count < 5 {
            
            // if less than 4 (number of buttons) words
            
            for wordIndex in 0 ..< wordsArray.count {
                if let button = buttonsArray[wordIndex] {
                    button.setTitle(wordsArray[wordIndex], for: .normal)
                }
            }
            
            for remainingButtonIndex in wordsArray.count ..< 4 {
                if let button = buttonsArray[remainingButtonIndex] {
                    button.setTitle("", for: .normal)
                }
            }
            
        } else {
            
            // if more than 4 words
            
            // generate arrays with random numbers
            let randomWordsIndecies = getRandomUniqueIntegers(amount: 4, minimum: 0, maximum: UInt32(wordsArray.count - 1), notIncluding: currentWord)
            //print(randomWordsIndecies)
            let randomButtonIndecies = getRandomInts(amount: 4, minimum: 0, maximum: 3)
            //print(randomButtonIndecies)
            // go through buttons
            for button in buttonsArray {
                if let button = button {
                    
                    correctAnswerIndex = randomButtonIndecies[0]
                    
                    if button == buttonsArray[correctAnswerIndex!] {
                        if let indexOfCollection = collectionIndex {
                            button.setTitle(wordCollections?.collections[indexOfCollection].words[currentWord].wordItself, for: .normal)
                        }
                    } else if button == buttonsArray[randomButtonIndecies[1]] {
                        button.setTitle(wordsArray[randomWordsIndecies[0]], for: .normal)
                    } else if button == buttonsArray[randomButtonIndecies[2]] {
                        button.setTitle(wordsArray[randomWordsIndecies[1]], for: .normal)
                    } else if button == buttonsArray[randomButtonIndecies[3]] {
                        button.setTitle(wordsArray[randomWordsIndecies[2]], for: .normal)
                    }
                }
            }
        }
    }
    
    // Random integers generators
    func getRandomInts(amount: Int, minimum: Int, maximum: UInt32) -> [Int] {
        var randomInts = Set<Int>()
        while randomInts.count < amount {
            
            randomInts.insert(Int(arc4random_uniform(maximum + 1)) + minimum)
            
        }
        return randomInts.shuffled()
    }
    
    func getRandomUniqueIntegers(amount: Int, minimum: Int, maximum: UInt32, notIncluding: Int?) -> [Int] {
        var randomInts = Set<Int>()
        while randomInts.count < amount {
            randomInts.insert(Int(arc4random_uniform(maximum + 1)) + minimum)
        }
        if let notToAdd = notIncluding {
            if randomInts.contains(notToAdd) {
                while randomInts.count < amount+1 {
                    randomInts.insert(Int(arc4random_uniform(maximum + 1)) + minimum)
                }
                randomInts.remove(notToAdd)
            }
        }
        return randomInts.shuffled()
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
