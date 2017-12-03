//
//  BookListViewController.swift
//  Bookmark
//
//  Created by Lucas Holland on 03.12.17.
//  Copyright © 2017 Lucas Holland. All rights reserved.
//

import UIKit
import os.log
class BookListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

     //   books = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self

        if let savedBooks = loadBooks() {
            books += savedBooks
        
        } else {
            books = createArray()
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }
    
    
    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditBook" {
            let indexPath = tableView.indexPathForSelectedRow!
            let book = books[indexPath.row]
            // let destinationController = segue.destination as! UINavigationController
            let destination = segue.destination as! BookDetailViewController //destinationController.viewControllers[0] as! BookDetailViewController
            destination.book = book
        }
    }
    
    @IBAction func unwindToBookList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! BookDetailViewController
        
        if let book = sourceViewController.book {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Editing an existing book
                books[selectedIndexPath.row] = book
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Adding a new book
                let newIndexPath = IndexPath(row: books.count, section: 0)
                books.append(book)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveBooks()
        }
    }
    //MARK: Loading & Saving Data
    private func saveBooks() {
        os_log("Attempting to save books", log: OSLog.default, type: .debug)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(books, toFile: Book.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Books successfully saved", log: OSLog.default, type: .debug)
        } else {
            os_log("Error saving books", log: OSLog.default, type: .error)
        }
    }
    
    private func loadBooks() -> [Book]? {
        os_log("Attempting to load books", log: OSLog.default, type: .debug)
        return NSKeyedUnarchiver.unarchiveObject(withFile: Book.ArchiveURL.path) as? [Book]
    }
    
    func createArray() -> [Book] {
        var tempBooks: [Book] = []
        let zero = Book(title: "Zero", author: "Marc Elsberg", pages: 400, currentPage: 71, cover: #imageLiteral(resourceName: "zero"))
        let sapiens = Book(title: "Sapiens", author: "Yuval Noah Harari", pages: 700, currentPage: 700, cover: #imageLiteral(resourceName: "sapiens"))
        tempBooks.append(zero)
        tempBooks.append(sapiens)
        return tempBooks
    }
}

extension BookListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookCell
     
        cell.configure(for: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete //.delete
    }
    
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.books[sourceIndexPath.row]
        books.remove(at: sourceIndexPath.row)
        books.insert(movedObject, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(books)")
        tableView.reloadData()
        saveBooks()
    }
    
    
    

    
     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            books.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveBooks()
        }
    }
}
