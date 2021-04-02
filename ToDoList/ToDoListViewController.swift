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
}


