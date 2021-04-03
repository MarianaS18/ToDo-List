//
//  ViewController.swift
//  ToDoList
//
//  Created by Mariana Steblii on 02/04/2021.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        // did set runs when selected category gets set with a value
        didSet {
            loadItems()
        }
    }
    
    // UIApplication.shared - singleton app instance of the current app
    // delegate - delegate of app object
    // we casting UIApplication.shared.delegate as our class AppDelegate, so we have accec to our class
    // we get the AppDelegates property - persistentContainer
    // we get a viewContext of persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - TableView Datasource methods
    
    // number of cells in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // create a cell and return it to the table view
    // method calls for every cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        
        // add or remove a checkmark to celected cell
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK: - TableView Delegate methods
    
    // works with selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // remove an item from database
        // context.delete(itemArray[indexPath.row])
        // removes an item from array whitch is used to load up the tableview data source
        // itemArray.remove(at: indexPath.row)
        
        // checks done property
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // saves context to persistent container
        saveItems()
        
        // selection dissapears slowly 
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    // runs when user presses add(+) button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // create alert
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        // create action to alert
        // runs when user clicks "Add Item" on alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Item - en entity (tabelnavn)
            let newItem = Item(context: self.context)
            newItem.title = textField.text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        // create textfield in the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // adds action to alert
        alert.addAction(action)
        
        // shows alert on the screen
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Model Manipulation Methods
    func saveItems() {
        do {
            // data gemmes fra context til persistent container
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        // reloads table view, so we can se the new item and if a cell was selected or unselected
        self.tableView.reloadData()
    }
    
    // Item.fetchRequest() - fetches all items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // the query that get only items from the selected category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            // saves result of request in array
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
}


// MARK: - UISearchBarDelegate

extension ToDoListViewController: UISearchBarDelegate {
    
    // this tells the delegate that the search button was tapped
    // and here we want to reload table view with the text, that user has tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // request that fetches all items
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // specifies what we want back wrom request
        // [cd] - specifies case and diacritic insensitivity
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // sort the data whitch we get back
        // ascending: true - sort the data in alphabetical order
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        // run our request and fetch the result
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // DispatchQueue is a manager who assign projekts to different threads
            DispatchQueue.main.async {
                // notifies that search bar is no longer selected and keybord should go away
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

