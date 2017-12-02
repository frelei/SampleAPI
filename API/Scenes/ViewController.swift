//
//  ViewController.swift
//  API
//
//  Created by Rodrigo F Leite on 02/12/17.
//  Copyright © 2017 Rodrigo F Leite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var posts = [Post]()
    
    // MARK: - IBOUTLET
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    // MARK: - Vc Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Get all the posts and reload the table view
    }

    // MARK: - IBACTION
    
    @IBAction func didTouchInsert(_ sender: UIButton) {
        if let author = authorTextField.text,
            let message = messageTextField.text,
            !author.isEmpty , !message.isEmpty {
            // TODO: Insert the post element to the table view
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier, for: indexPath)
        if let cell = cell as? PostsTableViewCell {
            let post = posts[indexPath.row]
            cell.setup(post: post)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // TODO: Delete post on the server and remove from the list 
        if editingStyle == .delete {
            self.posts.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
}
