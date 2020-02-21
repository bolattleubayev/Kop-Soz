//
//  CollectionsTableViewCell.swift
//  Kop Soz
//
//  Created by macbook on 12/29/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class CollectionsTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var collectionNameTextField: UITextField! {
        didSet {
            collectionNameTextField.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var resignationHandler: (() -> Void)?
    
    func textFieldDidEndEditing(_ collectionNameTextField: UITextField) {
        resignationHandler?() // when someone is interested in resignation of the cell, anyone can go and edit it
    }
    
    // puts keyboard away once you hit enter, if you don't do this, keyboard will stay up
    func textFieldShouldReturn(_ collectionNameTextField: UITextField) -> Bool {
        collectionNameTextField.resignFirstResponder()
        return true
    }
}
