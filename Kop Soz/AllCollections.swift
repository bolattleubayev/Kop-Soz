//
//  AllCollections.swift
//  Kop Soz
//
//  Created by macbook on 1/7/20.
//  Copyright © 2020 bolattleubayev. All rights reserved.
//

import Foundation

struct AllCollections: Codable {
    
    var collections = [WordCollection]()
    
    struct WordCollection: Codable {
        
        var collectionName: String?
        var words = [WordInCollection]()
        
        struct WordInCollection: Codable {
            let wordItself: String
            let wordDescription: String
            //let wordImage: String
        }
    }
    
    // failable initializer, if it fails, the other initializer will take place
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(AllCollections.self, from: json){
            self = newValue
        } else {
            return nil
        }
    }
    
    // getting JSON file, actually it is never going to fail, because all types are 100% codable
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(collections: [WordCollection]){
        self.collections = collections
    }
    
    init() {
        self.init(collections: [])
    }
}
