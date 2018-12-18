//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Admin on 12/17/18.
//  Copyright © 2018 omar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategory()
    }

    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
    
        return cell
    }
    
    //MARK - Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
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
    
    func saveCategory() {
        
        do{
            try context.save()
        }catch{
            print("Error to add category \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK - load Category Methods
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
           categoryArray = try context.fetch(request)
        }catch {
            print("Cann't fetch data \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let distenationVC = segue.destination as! TodoeyListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            distenationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    

}
