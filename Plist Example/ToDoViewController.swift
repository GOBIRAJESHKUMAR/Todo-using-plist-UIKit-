//
//  ToDoViewController.swift
//  Core-Data
//
//  Created by Rajesh Kumar on 29/08/22.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var todoArray = [ItemList]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        loadItems()
        
       
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoList", for: indexPath)
        
        cell.textLabel?.text = todoArray[indexPath.row].name
        
        cell.accessoryType = todoArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        todoArray[indexPath.row].done = !todoArray[indexPath.row].done
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    @IBAction func AddButton(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add List", style: .default) { (action) in

            let item = ItemList()
            
            if textField.text != "" {
                guard let newItem = textField.text else { return }
                item.name = newItem
                self.todoArray.append(item)
                
                self.saveItems()
            }
            
        }

        alert.addTextField { alerttextField in
            alerttextField.placeholder = "Create New List"
            textField = alerttextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)

    }
    
    
    func saveItems() {
        let encoder = PropertyListEncoder()
    
        do {
            let data = try encoder.encode(todoArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems() {
        guard let data = try? Data(contentsOf: dataFilePath!) else { return }
            let decoder = PropertyListDecoder()
            do{
            todoArray = try decoder.decode([ItemList].self, from: data)
            } catch {
                print(error)
            }
        }
    
}
