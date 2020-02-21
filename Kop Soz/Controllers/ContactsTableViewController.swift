//
//  ContactsTableViewController.swift
//  Kop Soz
//
//  Created by macbook on 1/20/20.
//  Copyright © 2020 bolattleubayev. All rights reserved.
//

import UIKit
import SafariServices

class ContactsTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    var sectionTitles = ["Feedback", "Follow US"]
    
    var sectionContent = [[(text: "Rate us on AppStore", link: "https://www.apple.com/itunes/charts/paid-apps"),
    (text: "Tell us your feedback", link: "https://www.appcoda.com/contact")],
    [(text: "Twitter", link: "https://www.twitter.com/appcodamobile"),
    (text: "Facebook", link: "https://www.facebook.com/appcodamobile"),
    (text: "Instagram", link: "https://www.instagram.com/appcodamobile")]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.3430483341, blue: 0.7046421766, alpha: 1)
        tableView.contentInsetAdjustmentBehavior = .never
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaults.integer(forKey: "language") == 0 {
            sectionTitles = ["Баға беру", "Еру"]
            
            sectionContent = [[(text: "AppStore-да баға беру", link: "https://apps.apple.com/kz/app/kop-soz/id1494623354")],
            [(text: "Facebook", link: "https://www.facebook.com/tleubayev"),
            (text: "Instagram", link: "https://www.instagram.com/bolattleubayev")]]
            
        } else if defaults.integer(forKey: "language") == 1 {
            sectionTitles = ["Обратная связь", "Подписаться"]
            
            sectionContent = [[(text: "Дать оценку на AppStore", link: "https://apps.apple.com/kz/app/kop-soz/id1494623354")],
            [(text: "Facebook", link: "https://www.facebook.com/tleubayev"),
            (text: "Instagram", link: "https://www.instagram.com/bolattleubayev")]]
        } else {
            sectionTitles = ["Feedback", "Follow us"]
            
            sectionContent = [[(text: "Rate on AppStore", link: "https://apps.apple.com/kz/app/kop-soz/id1494623354")],
            [(text: "Facebook", link: "https://www.facebook.com/tleubayev"),
            (text: "Instagram", link: "https://www.instagram.com/bolattleubayev")]]
        }
    }
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet{
            logoImageView.layer.cornerRadius = logoImageView.frame.height / 2.0
            logoImageView.layer.masksToBounds = true
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath) as! AboutTableViewCell

        // Configure the cell...
        let cellData = sectionContent[indexPath.section][indexPath.row]
        cell.aboutLabel?.text = cellData.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let link = sectionContent[indexPath.section][indexPath.row].link
        
        switch indexPath.section {
        // Leave us fedback section
        case 0:
            if let url = URL(string: link) {
                let safariContoller = SFSafariViewController(url: url)
                present(safariContoller, animated: true, completion: nil)
            }
        // Follow us section
        case 1:
            if let url = URL(string: link) {
                let safariContoller = SFSafariViewController(url: url)
                present(safariContoller, animated: true, completion: nil)
            }
        default:
            break
        }
        
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let headerView = view as! UITableViewHeaderFooterView
        
        headerView.tintColor = UIColor.clear
        
        headerView.textLabel?.textColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        headerView.textLabel?.font = UIFont(name: "GillSans-SemiBoldItalic", size: 23)
    }
   
}
