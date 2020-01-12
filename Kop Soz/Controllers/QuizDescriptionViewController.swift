//
//  QuizDescriptionViewController.swift
//  Kop Soz
//
//  Created by macbook on 1/7/20.
//  Copyright © 2020 bolattleubayev. All rights reserved.
//

import UIKit

class QuizDescriptionViewController: UIViewController {
    
    var wordDescriptionText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        wordDescription.text = wordDescriptionText
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    }
    

    @IBOutlet weak var wordDescription: UITextView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
