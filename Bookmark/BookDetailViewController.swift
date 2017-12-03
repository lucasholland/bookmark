//
//  EditBookTableViewController.swift
//  Bookmark
//
//  Created by Lucas Holland on 03.12.17.
//  Copyright © 2017 Lucas Holland. All rights reserved.
//

import UIKit

class BookDetailViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    
    @IBOutlet weak var currentPageTextField: UITextField!
    @IBOutlet weak var pagesTextField: UITextField!
    
    @IBOutlet weak var coverImage: UIImageView!
    
    var book: Book?
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        coverImage.contentMode = UIViewContentMode.scaleAspectFit
        if let book = book {
            // Editing
            titleTextField.text = book.title
            authorTextField.text = book.author
            currentPageTextField.text = String(book.currentPage)
            pagesTextField.text = String(book.pages)
            coverImage.image = book.cover
        }

    }
    
    @IBAction func bookCoverTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] {
            coverImage.image = pickedImage as? UIImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "saveUnwind" {
            book = Book(title: titleTextField.text!, author: authorTextField.text!, pages: Int(pagesTextField.text!)!, currentPage: Int(currentPageTextField.text!)!, cover: coverImage.image!)
            
        }
    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
