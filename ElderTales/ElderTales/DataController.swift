//
//  DataController.swift
//  ElderTales
//
//  Created by student on 24/04/24.
//

import Foundation
import SwiftUI

var users: [User] = []
var posts: [Post] = []
var lives: [Live] = []
var comments: [Comment] = []
var categories: [Category] = []



func generateDummyData(){
        
        // Create dummy categories
        categories = [
            Category(title: "Travel", image: (UIImage(named: "travel") ?? UIImage(systemName: "person.fill")) ?? UIImage()),
            Category(title: "Cooking", image: UIImage(named: "cooking") ?? UIImage())
        ]
        
        // Create dummy users
        users = [
            User(name: "Alice Smith", email: "alice@example.com", isElderly: false, password: "password123", image: UIImage(named: "profile1") ?? UIImage(), likedPosts: [], savedPosts: [], following: [], interests: categories),
            User(name: "Bob Johnson", email: "bob@example.com", isElderly: true, password: "password456", image: UIImage(named: "profile2") ?? UIImage(), likedPosts: [], savedPosts: [], following: [], interests: categories)
        ]
        
        // Create dummy comments
        comments = [
            Comment(postedBy: users[0], postedOn: Date(), body: "Great post!"),
            Comment(postedBy: users[1], postedOn: Date(), body: "Really enjoyed this.")
        ]
        
        // Create dummy posts
        posts = [
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[1], postedOn: Date(), length: 90, title: "Home Cooking Tips", cover: UIImage(named: "cooking") ?? UIImage(), likes: 75, comments: comments, shares: 5, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
            Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: categories),
        ]
        
        // Assign liked and saved posts to users
        users[0].likedPosts.append(contentsOf: posts)
        users[0].savedPosts.append(posts[1])
        users[1].likedPosts.append(posts[0])
        users[1].savedPosts.append(contentsOf: posts)
        
        // Users following each other
        users[0].following.append(users[1])
        users[1].following.append(users[0])
        
        // Create dummy lives
        lives = [
            Live(postedBy: users[0], postedOn: Date(), beginsOn: Date().addingTimeInterval(3600), interested: users)
        ]
    }
