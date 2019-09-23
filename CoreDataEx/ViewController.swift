//
//  ViewController.swift
//  coreRealmTableView
//
//  Created by IMAC on 8/29/19.
//  Copyright © 2019 IMAC. All rights reserved.
//

import UIKit
import CoreData



class ViewController: UITableViewController {
    
    var itemArray = [Item]()//This is item is core data entity which having title and done types
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //printing location path where core data stored
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       print("filePath  \(dataFilePath)")
        
        //Read or display the saved items
        //let request : NSFetchRequest<Item> = Item.fetchRequest()//Fetching data which stored
        displayItems()
        }
    
    //MARK : - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoList", for: indexPath)
       
        let cellItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = cellItem.title//This title is in core data
        
        cell.accessoryType = cellItem.done ? .checkmark : .none //Ternary ooperator
        
        return cell
    }
    
    //Mark : - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //TODO: This is for checkmark or none when we click it
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        //itemArray[indexPath.row].done != itemArray[indexPath.row].done
        
        
        //MARK: Delete Core data items
//        //itemArray.remove(at: indexPath.row)
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        
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
    
    @IBAction func addList(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add an event", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            
            if textField.text == "" {
                alert.message = "Enter data"
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
            let newArray = Item(context: self.context)//Item is core data entity
            newArray.title = textField.text!//These two title and done are from core data entity
            newArray.done = false
           
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
    func displayItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()//Fetching data which stored
        do{
            itemArray =  try context.fetch(request)//Read
        }
        catch {
            print("Error while reading \(error)")
        }
        
    }
    
    
    

}

//MARK: SearchBarMethods
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)//This is used to print  the item entered in searchBar
        //This predicate format checks title(Item) contains in %@(in search bar)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)//Showing searched data in acending order
        request.sortDescriptors = [sortDescriptor]
        
       displayItems()
    }
    //Go to Back to original list
    //After searching click cancel it will come to normal list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
           displayItems() //displayItems(with: <#T##NSFetchRequest<Item>#>)//Reload the tableView
            
            
            DispatchQueue.main.async {
                
                //This will hide the Keyboard also
                searchBar.resignFirstResponder()//This is to resign the didFinishTyping
            }
           
        }
    }
}

//MARK: Search bar for normal array data

//let countryNameArr = ["Afghanistan", "Albania", "Algeria", "American Samoa"]
//var searchedCountry = [String]()
//var searching = false

//func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//       searchedCountry = countryNameArr.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
//       searching = true
//       tblView.reloadData()
//   }
//
//   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//       searching = false
//       searchBar.text = ""
//       tblView.reloadData()
//   }

