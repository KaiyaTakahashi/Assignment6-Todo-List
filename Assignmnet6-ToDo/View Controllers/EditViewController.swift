//
//  EditViewController.swift
//  Assignmnet6-ToDo
//
//  Created by Kaiya Takahashi on 2022-05-13.
//

import UIKit

protocol EditViewControllerDelegate {
    func addToDoItem(_ toDoItem: ToDoItem)
    func editToDoItem(indexPath: IndexPath, name: String)
}

class EditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var toDoItemTextField: UITextField!
    var delegate: EditViewControllerDelegate?
    var textForToDoItemTextField: String?
    var indexPath: IndexPath?
    
    override func viewWillAppear(_ animated: Bool) {
        if self.title! == "Edit Todo Item" {
            toDoItemTextField.text = textForToDoItemTextField
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoItemTextField.delegate = self
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if self.title! == "Add Todo Item" {
            let userInput = toDoItemTextField.text!
            let newToDoItem = ToDoItem(name: userInput, isDone: false)
            delegate?.addToDoItem(newToDoItem)
            navigationController?.popViewController(animated: true)
        } else if self.title! == "Edit Todo Item" {
            let userInput = toDoItemTextField.text!
            delegate?.editToDoItem(indexPath: indexPath!, name: userInput)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (toDoItemTextField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if text.isEmpty {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
        return true
    }
    
}
