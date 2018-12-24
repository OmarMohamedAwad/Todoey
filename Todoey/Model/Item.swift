//
//  Item.swift
//  Todoey
//
//  Created by Admin on 12/18/18.
//  Copyright © 2018 omar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var date : Date?
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
   let perantCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}

