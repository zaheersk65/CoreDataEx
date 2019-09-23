//
//  CategoryViewController.swift
//  CoreDataEx
//
//  Created by IMAC on 9/20/19.
//  Copyright © 2019 IMAC. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var itemArray = [Category]()//This is item is core data entity which having title and done types
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Path
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
        
        //Read or display the saved items
        //let request : NSFetchRequest<Item> = Item.fetchRequest()//Fetching data which stored
        displayItems()

    }

    
    
    //MARK : - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryViewController", for: indexPath)
        
        let cellItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = cellItem.name//This title is in core data
        
        //cell.accessoryType = cellItem.done ? .checkmark : .none //Ternary ooperator
        
        return cell
    }
    
    //Mark : - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //MARK: update or after delete it save and update
        saveItems()
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            //MARK: update or after delete it save and update
            saveItems()
        }
    }
    
    
    //MARK: Core Data
    //This is for adding core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBAction func addEvents(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add an event", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            
            if textField.text == "" {
                alert.message = "Enter data"
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                let newArray = Category(context: self.context)//Item is core data entity
                newArray.name = textField.text!//These two title and done are from core data entity
                
                
                self.itemArray.append(newArray)
                
                //This will go to Create data and save
                self.saveItems()
            }
            
            self.tableView.reloadData()
        }))
        //This is for adding textField in alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter item name"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
        print("Selected")
    }
        
    


//MARK: Model Manupulation Methods
//core data
//Creating/saving data here
func saveItems() {
    do{
        
        try context.save()//Save/Create
        
    }catch {
        print("Error in saving \(error)")
        
    }
    tableView.reloadData()
}

//Read the data after saving like displying again
func displayItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    
    //        let request : NSFetchRequest<Item> = Item.fetchRequest()//Fetching data which stored
    do{
        itemArray =  try context.fetch(request)//Read
    }
    catch {
        print("Error while reading \(error)")
    }
    
}
    
}
