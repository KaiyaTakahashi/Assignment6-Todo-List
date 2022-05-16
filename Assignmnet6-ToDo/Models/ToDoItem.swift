//
//  ToDoItem.swift
//  Assignmnet6-ToDo
//
//  Created by Kaiya Takahashi on 2022-05-13.
//

import Foundation

struct ToDoItem: Codable {
    var name: String
    var isDone: Bool
    
    static var archiveURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsURL.appendingPathComponent("todoList").appendingPathExtension("plist")
        return archiveURL
    }
    
    static var sampleTodoItems: [[ToDoItem]] {
        return [
                [
                    ToDoItem(name: "Take a Walk", isDone: true),
                    ToDoItem(name: "Study Design pattern", isDone: true)
                ],
                [
                    ToDoItem(name: "Study iOS", isDone: true),
                    ToDoItem(name: "Update Resume", isDone: false)
                ],
                [
                    ToDoItem(name: "Watch Netflix", isDone: false)
                ]
            ]
    }
    
    static func saveToFile(toDoItems: [[ToDoItem]]) {
        let encoder = PropertyListEncoder()
        do {
            let encodedToDoItems = try encoder.encode(toDoItems)
            try encodedToDoItems.write(to: ToDoItem.archiveURL)
        } catch {
            print("Error encoding file: \(error.localizedDescription)")
        }
    }
    
    static func loadFromFile() -> [[ToDoItem]]? {
        guard let toDoItemData = try? Data(contentsOf: ToDoItem.archiveURL) else {return nil}
        let decoder = PropertyListDecoder()
        do {
            let decodedToDoItem = try decoder.decode([[ToDoItem]].self, from: toDoItemData)
            return decodedToDoItem
        } catch {
            print("Error decoding file: \(error.localizedDescription)")
            return nil
        }
    }
}
