//
//  AppDelegate.swift
//  Todoey
//
//  Created by Admin on 12/14/18.
//  Copyright © 2018 omar. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
        }
        catch {
            print("Installation error realm \(error)")
        }
        return true
    }

    
}

