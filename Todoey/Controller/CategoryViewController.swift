//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hrutuja Kamthe on 29/01/25.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Cat]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories[indexPath.row]
            }
        }
    
    //MARK: Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            ///what will happen when user clicks the Add Item button on our alert
            let newCategory = Cat(context: self.context)
            newCategory.name = textfield.text!
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
           try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Cat> = Cat.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }

}
