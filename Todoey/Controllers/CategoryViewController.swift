//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Admin on 12/17/18.
//  Copyright © 2018 omar. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    var categoryArray : Results<Category>?
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategory()
    }

    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category yet"
    
        return cell
    }
    
    //MARK - Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add category", style: .default) { (action) in
            let newCategory = Category()
            
            newCategory.name = textField.text!
           
            self.saveCategory(category: newCategory)
        }
        
        alert.addTextField { (alertText) in
            alertText.placeholder = "Create new category"
            textField = alertText
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Data Manuplation Methods
    
    //MARK - Save New Category
    
    func saveCategory(category : Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error to add category \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK - load Category Methods
    
    func loadCategory() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let distenationVC = segue.destination as! TodoeyListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            distenationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    

}
