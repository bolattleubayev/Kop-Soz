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
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        wordDescription.text = wordDescriptionText
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 193.0/255.0, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.integer(forKey: "language") == 0 {
            closeButtonOutlet.setTitle("Жабу", for: [])
        } else if defaults.integer(forKey: "language") == 1 {
            closeButtonOutlet.setTitle("Закрыть", for: [])
        } else {
            closeButtonOutlet.setTitle("Close", for: [])
        }
    }
    
    @IBOutlet weak var closeButtonOutlet: UIButton!
    
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
