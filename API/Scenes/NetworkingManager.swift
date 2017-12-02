//
//  NetworkingManager.swift
//  API
//
//  Created by Rodrigo F Leite on 02/12/17.
//  Copyright © 2017 Rodrigo F Leite. All rights reserved.
//

import Foundation

struct NetworkingManager {
    
    static let url = "http://localhost:3000/posts"
    
    
    /// posts
    ///   Get all the posts on the database
    /// - Parameter completionHandler: Result<[Post]>
    static func posts(_ completionHandler: @escaping (Result<[Post]>) -> Void) {
        if let urlResource = URL(string: url) {
            let session = URLSession(configuration: .ephemeral)
            session.dataTask(with: urlResource) { (data, response, error) in
                if let error = error {
                    completionHandler(.failure(error.localizedDescription))
                } else {
                    let decoder = JSONDecoder()
                    do {
                        let posts = try decoder.decode([Post].self, from: data!)
                        completionHandler(.success(posts))
                    } catch let decodeError as NSError {
                        completionHandler(.failure(decodeError.localizedDescription))
                    }
                }
            }.resume()
        }
    }
    
    /// insert post
    ///   add a new post to the database
    /// - Parameters:
    ///   - post: post data
    ///   - completionHandler: Result<Post>
    static func insert(post: Post, _ completionHandler: @escaping (Result<Post>) -> Void) {
        if let urlResource = URL(string: url) {
            var urlRequest = URLRequest(url: urlResource)
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            urlRequest.httpMethod = "POST"
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(post)
                urlRequest.httpBody = data
                let session = URLSession(configuration: .ephemeral)
                session.dataTask(with: urlRequest) { (data, response, error) in
                    if let error = error {
                        completionHandler(.failure(error.localizedDescription))
                    } else {
                        let decoder = JSONDecoder()
                        do {
                            let post = try decoder.decode(Post.self, from: data!)
                            completionHandler(.success(post))
                        } catch let decodeError as NSError {
                            completionHandler(.failure(decodeError.localizedDescription))
                        }
                    }
                }.resume()
            } catch let encodeError as NSError {
               completionHandler(.failure(encodeError.localizedDescription))
            }
        }
    }
    
    /// delete post
    ///
    /// - Parameters:
    ///   - post: post data
    ///   - completionHandler: Result<Any>
    static func delete(post: Post, _ completionHandler: @escaping (Result<Any>) -> Void) {
        let path = url + "/\(post.id)"
        if let urlResource = URL(string: path) {
            var urlRequest = URLRequest(url: urlResource)
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            urlRequest.httpMethod = "DELETE"
            let session = URLSession(configuration: .ephemeral)
            session.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completionHandler(.failure(error.localizedDescription))
                } else {
                    completionHandler(.success(Void.self))
                }
            }.resume()
        }
    }
    
    
}
