//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Mariana Steblii on 03/04/2021.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    // UIApplication.shared - singleton app instance of the current app
    // delegate - delegate of app object
    // we casting UIApplication.shared.delegate as our class AppDelegate, so we have accec to our class
    // we get the AppDelegates property - persistentContainer
    // we get a viewContext of persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }


    // MARK: - Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // create alert
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // create action to alert
        // runs when user click "Add Category"
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // ItemCategory - the table
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.categoryArray.append(newCategory)
            self.safeCategories()
        }
        
        // create textfield in the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        
        // adds action to alert
        alert.addAction(action)
        
        // shows alert on the screeen
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - TableView Data Source Methods
    
    // number of cells in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    // create a cell and return it to the table view
    // method calls for every cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    
    // MARK: - TbaleView Delegate Methods
    
    // runs when we celect a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // change from CategoryViewController to ToDoLostViewController
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // runs just before performSegue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // we set the destination viewController to ToDoListViewController
        let destinationVC = segue.destination as! ToDoListViewController
        // we take the category that coresponds to the celected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    // MARK: - Data manipulation methods
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Eror fetching data from context, \(error)")
        }
    }
    
    func safeCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
}
