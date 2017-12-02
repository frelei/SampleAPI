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
    @IBOutlet weak var authorTextField: UITextField! {
        didSet {
            authorTextField.delegate = self
        }
    }
    @IBOutlet weak var messageTextField: UITextField! {
        didSet {
            messageTextField.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Vc Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Get all the posts and reload the table view
        activityIndicator.startAnimating()
        NetworkingManager.posts { [weak self] (result) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.activityIndicator.stopAnimating()
            }

            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    strongSelf.posts = posts
                    strongSelf.tableView.reloadData()
                }
            case .failure(let message): print(message)
            }
        }
    }

    // MARK: - IBACTION
    @IBAction func didTouchInsert(_ sender: UIButton) {
        if let author = authorTextField.text,
            let message = messageTextField.text,
            !author.isEmpty , !message.isEmpty {
            // TODO: Insert the post element to the table view
            let post = Post(id: 0, message: message, author: author)
            activityIndicator.startAnimating()
            NetworkingManager.insert(post: post) { [weak self] (result) in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.activityIndicator.stopAnimating()
                }

                switch result {
                case .success(let post):
                    strongSelf.posts.append(post)
                    let indexPath = IndexPath(row: strongSelf.posts.count-1, section: 0)
                    DispatchQueue.main.async {
                        strongSelf.tableView.beginUpdates()
                        strongSelf.tableView.insertRows(at: [indexPath], with: .middle)
                        strongSelf.tableView.endUpdates()
                        strongSelf.authorTextField.text = ""
                        strongSelf.messageTextField.text = ""
                    }
                case .failure(let message):
                    print(message)
                }
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(PostsTableViewCell.height)
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
            activityIndicator.startAnimating()
            
            let post = posts[indexPath.row]
            NetworkingManager.delete(post: post) { [weak self ] (result) in
                guard let strongSelf = self else { return  }
                DispatchQueue.main.async {
                    strongSelf.activityIndicator.stopAnimating()
                }

                switch result {
                case .success:
                    strongSelf.posts.remove(at: indexPath.row)
                    strongSelf.tableView.beginUpdates()
                    strongSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
                    strongSelf.tableView.endUpdates()
                    
                case .failure(let message):
                    print(message)
                }
            }
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
