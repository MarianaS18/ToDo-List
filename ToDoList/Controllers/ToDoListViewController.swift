//
//  ViewController.swift
//  ToDoList
//
//  Created by Mariana Steblii on 02/04/2021.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray = [Item]()
    
    // users default database
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var newItem1 = Item()
        newItem1.title = "Køb æbler"
        itemArray.append(newItem1)
        
        var newItem2 = Item()
        newItem2.title = "Kør til lægen"
        itemArray.append(newItem2)
        
        var newItem3 = Item()
        newItem3.title = "Lav lektier i iOS"
        itemArray.append(newItem3)
        
        // add array with data to dafault users database
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
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
        // checks done property
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // selection dissapears slowly 
        tableView.deselectRow(at: indexPath, animated: true)
        
        // reloads table view, so we can se if a cell was selected or unselected
        tableView.reloadData()
    }
    
    // MARK: - Add New Items
    
    // runs when user presses add(+) button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItem = UITextField()
        
        // create alert
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        // create action to alert
        // runs when user clicks "Add Item" on alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if newItem.text != "" {
                self.itemArray.append(Item(title: newItem.text!, done: false))
            }
            
            // add a new Item to default database
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            // reloads table view, so we can se the new item
            self.tableView.reloadData()
        }
        
        // create textfield in the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItem = alertTextField
        }
        
        // adds action to alert
        alert.addAction(action)
        
        // shows alert on the screen
        present(alert, animated: true, completion: nil)
    }
}


