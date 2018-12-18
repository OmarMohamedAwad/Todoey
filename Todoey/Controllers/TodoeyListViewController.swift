//
//  ViewController.swift
//  Todoey
//
//  Created by Admin on 12/14/18.
//  Copyright © 2018 omar. All rights reserved.
//

import UIKit
import CoreData

class TodoeyListViewController: UITableViewController {

    var itemArray = [Item]()
   
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask))
        
        
//        if let item = userDefult.array(forKey: "ToDoItemCell") as? [Item] {
//             itemArray = item
//        }
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItem()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
    
    //MARK - Model Manuplation Methods
    
    func saveItem(){
        
        do {
           try context.save()
        } catch {
            print("Error saving contect \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), prdicat : NSPredicate? = nil){
     
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let addtionPredicate = prdicat {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        
        do {
           itemArray = try context.fetch(request)
            
        }catch {
            print("Error in fetching \(error)")
        }
        tableView.reloadData()
    }
    
    
}

//MARK - Search Bar method

extension TodoeyListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINs[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with : request, prdicat: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        }
    }
    
    
}


