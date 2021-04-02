//
//  ViewController.swift
//  ToDoList
//
//  Created by Mariana Steblii on 02/04/2021.
//

import UIKit

class ToDoListViewController: UITableViewController {
    let itemArray = ["Køb æbler", "Kør til lægen", "Lav lektier i iOS"]

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
}


