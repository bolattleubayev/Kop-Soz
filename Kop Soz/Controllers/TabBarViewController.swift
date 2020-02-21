//
//  TabBarViewController.swift
//  Kop Soz
//
//  Created by macbook on 2/21/20.
//  Copyright © 2020 bolattleubayev. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeNamesOfTabs(notification:)), name: Notification.Name("LanguageChanged"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("LanguageChanged"), object: nil)
    }
    
    @objc func changeNamesOfTabs(notification: Notification) {
        
        if defaults.integer(forKey: "language") == 0 {
            tabBar.items?[0].title = "Қосу"
            tabBar.items?[1].title = "Оқу"
            tabBar.items?[2].title = "Тест"
            tabBar.items?[3].title = "Теңшеулер"
        } else if defaults.integer(forKey: "language") == 1 {
            tabBar.items?[0].title = "Добавить"
            tabBar.items?[1].title = "Учить"
            tabBar.items?[2].title = "Тест"
            tabBar.items?[3].title = "Наcтройки"
        } else {
            tabBar.items?[0].title = "Add"
            tabBar.items?[1].title = "Learn"
            tabBar.items?[2].title = "Test"
            tabBar.items?[3].title = "Settings"
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
