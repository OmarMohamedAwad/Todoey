//
//  Category.swift
//  Todoey
//
//  Created by Admin on 12/18/18.
//  Copyright © 2018 omar. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
