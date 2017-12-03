//
//  Book.swift
//  Bookmark
//
//  Created by Lucas Holland on 03.12.17.
//  Copyright © 2017 Lucas Holland. All rights reserved.
//

import Foundation
import UIKit
import os

class Book: NSObject, NSCoding {
    //MARK: Properties
    var cover: UIImage
    var title: String
    var author: String
    var pages: Int
    var currentPage: Int
    //MARK: Initialisers
    init(title: String, author: String, pages: Int, currentPage: Int, cover: UIImage) {
        self.title = title
        self.author = author
        self.pages = pages
        self.currentPage = currentPage
        self.cover = cover
    }
    //MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        os_log("Attempting to decode book object", log: OSLog.default, type: .debug)
        guard let title = aDecoder.decodeObject(forKey: PropertyKeys.title) as? String else {
            os_log("Unable to decode book title", log: OSLog.default, type: .debug)
            return nil
        }
        guard let author = aDecoder.decodeObject(forKey: PropertyKeys.author) as? String else {
            os_log("Unable to decode book author", log: OSLog.default, type: .debug)
            return nil
        }
        guard let cover = aDecoder.decodeObject(forKey: PropertyKeys.cover) as? UIImage else {
            os_log("Unable to decode book cover", log: OSLog.default, type: .debug)
            return nil
        }
         let pages = aDecoder.decodeInteger(forKey: PropertyKeys.pages)

        let currentPage = aDecoder.decodeInteger(forKey: PropertyKeys.currentPage) 
        self.init(title: title, author: author, pages: pages, currentPage: currentPage, cover: cover)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKeys.title)
        aCoder.encode(author, forKey: PropertyKeys.author)
        aCoder.encode(cover, forKey: PropertyKeys.cover)
        aCoder.encode(pages, forKey: PropertyKeys.pages)
        aCoder.encode(currentPage, forKey: PropertyKeys.currentPage)
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("books")

    
}

struct PropertyKeys {
    static let title = "title"
    static let author = "author"
    static let pages = "pages"
    static let currentPage = "currentPage"
    static let cover = "cover"
}
