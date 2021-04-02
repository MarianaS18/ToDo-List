//
//  ViewController.swift
//  ToDoList
//
//  Created by Mariana Steblii on 02/04/2021.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray = ["Køb æbler", "Kør til lægen", "Lav lektier i iOS"]

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    
    // MARK: - TableView Delegate methods
    
    // works with selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            // remove the checkmark, if it was checked
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            // add checkmark to celected cell
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // selection dissapears slowly 
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    // runs when user presses add(+) button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItem = UITextField()
        
        // create alert
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        // create action to alert
        // runs when user clicks "Add Item" on alert
        // add a new Item to ToDo List
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if newItem.text != "" {
                self.itemArray.append(newItem.text!)
            }
            
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


