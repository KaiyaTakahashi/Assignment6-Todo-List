//
//  ToDoItemsTableViewController.swift
//  Assignmnet6-ToDo
//
//  Created by Kaiya Takahashi on 2022-05-13.
//

import UIKit

class ToDoItemsTableViewController: UITableViewController, EditViewControllerDelegate {
    
    var toDoItems: [[ToDoItem]] = [] {
        didSet {
            ToDoItem.saveToFile(toDoItems: toDoItems)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
        if let storedToDoItems = ToDoItem.loadFromFile() {
            toDoItems = storedToDoItems
        } else {
            toDoItems = ToDoItem.sampleTodoItems
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "High Priority"
        } else if section == 1 {
            return "Medium Priority"
        } else {
            return "Low Priority"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriorityCell", for: indexPath)
        cell.showsReorderControl = true
        cell.accessoryType = .detailButton
        
        let toDoItem = toDoItems[indexPath.section][indexPath.row]
//        var content = cell.defaultContentConfiguration()
//        let text = (toDoItem.isDone) ? "✓\(toDoItem.name)": "\(toDoItem.name)"
//        content.text = text
//        cell.contentConfiguration = content
        cell.textLabel?.text = (toDoItem.isDone) ?  "✓\(toDoItem.name)" : "\(toDoItem.name)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedToDoItem = toDoItems[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        toDoItems[destinationIndexPath.section].insert(movedToDoItem, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            toDoItems[indexPath.section][indexPath.row].isDone.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths.reversed() {
                toDoItems[indexPath.section].remove(at: indexPath.row)
            }
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let editVC = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editVC.title = "Add Todo Item"
        editVC.delegate = self
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func addToDoItem(_ toDoItem: ToDoItem) {
        toDoItems[1].append(toDoItem)
        tableView.insertRows(at: [IndexPath(row: toDoItems[1].count - 1, section: 1)], with: .automatic)
    }
    
    func editToDoItem(indexPath: IndexPath, name: String) {
        toDoItems[indexPath.section][indexPath.row].name = name
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let editVC = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editVC.title = "Edit Todo Item"
        editVC.delegate = self
        editVC.indexPath = indexPath
        let textForEditToDoItemTextField = toDoItems[indexPath.section][indexPath.row].name
        editVC.textForToDoItemTextField = textForEditToDoItemTextField
        navigationController?.pushViewController(editVC, animated: true)
    }
}
