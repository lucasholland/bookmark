//
//  BookCell.swift
//  Bookmark
//
//  Created by Lucas Holland on 03.12.17.
//  Copyright © 2017 Lucas Holland. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var totalPagesLabel: UILabel!
    
    func configure(for book: Book) {
        coverImage.contentMode = UIViewContentMode.scaleAspectFit
        titleLabel.text = book.title
        authorLabel.text = book.author
        coverImage.image = book.cover
        currentPageLabel.text = String(book.currentPage)
        totalPagesLabel.text = "out of \(book.pages)"
    }
    
}
