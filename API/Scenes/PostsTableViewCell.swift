//
//  PostsTableViewCell.swift
//  API
//
//  Created by Rodrigo F Leite on 02/12/17.
//  Copyright © 2017 Rodrigo F Leite. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    // MARK: - CONSTANT
    static let identifier = "PostsTableViewCell"
    static let height = 100
    
    // MARK: - IBOUTLET
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override var reuseIdentifier: String? {
        return PostsTableViewCell.identifier
    }
    
    func setup(post: Post) {
        authorLabel.text = post.author
        messageLabel.text = post.message
    }

}
