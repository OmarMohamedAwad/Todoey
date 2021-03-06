//
//  ViewController.swift
//  Todoey
//
//  Created by Admin on 12/14/18.
//  Copyright © 2018 omar. All rights reserved.
//

import UIKit
import RealmSwift

class TodoeyListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask))
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "no item add"
        }
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch {
                print("error to update data \(error)")
            }
        }
       
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {

                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error to save item \(error)")
                }
                
                self.tableView.reloadData()
                
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
    
    //MARK - Model Manuplation Methods
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
}

//MARK - Search Bar method

extension TodoeyListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        
        tableView.reloadData()
        
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


