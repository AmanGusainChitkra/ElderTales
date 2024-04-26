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
        Category(title: "Travel", image: UIImage(named: "travel") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Cooking", image: UIImage(named: "cooking") ?? UIImage()),
        Category(title: "Sports", image: UIImage(named: "sports") ?? UIImage()),
        Category(title: "Music", image: UIImage(named: "music") ?? UIImage())
    ]
    
    // Create dummy users
    users = [
        User(name: "Alice Smith", email: "alice@example.com", isElderly: false, password: "password123", image: UIImage(named: "profile1") ?? UIImage(), likedPosts: [], savedPosts: [], following: [], interests: categories),
        User(name: "Bob Johnson", email: "bob@example.com", isElderly: true, password: "password456", image: UIImage(named: "profile2") ?? UIImage(), likedPosts: [], savedPosts: [], following: [], interests: categories),
        User(name: "Charlie Brown", email: "charlie@example.com", isElderly: false, password: "password789", image: UIImage(named: "profile3") ?? UIImage(), likedPosts: [], savedPosts: [], following: [], interests: categories)
    ]
    
    // Create dummy comments
    comments = [
        Comment(postedBy: users[0], postedOn: Date(), body: "Great post!"),
        Comment(postedBy: users[1], postedOn: Date(), body: "Really enjoyed this."),
        Comment(postedBy: users[2], postedOn: Date(), body: "Love this!")
    ]
    
    // Create dummy posts
    posts = [
        Post(postedBy: users[0], postedOn: Date(), length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), likes: 123, comments: comments, shares: 10, suitableCategories: [categories[0]]),
        Post(postedBy: users[1], postedOn: Date(), length: 90, title: "Home Cooking Tips", cover: UIImage(named: "cooking") ?? UIImage(), likes: 75, comments: comments, shares: 5, suitableCategories: [categories[1]]),
        Post(postedBy: users[2], postedOn: Date(), length: 150, title: "My Favorite Sports Moments", cover: UIImage(named: "sports") ?? UIImage(), likes: 200, comments: comments, shares: 20, suitableCategories: [categories[2]]),
        Post(postedBy: users[0], postedOn: Date(), length: 120, title: "How to Play the Guitar", cover: UIImage(named: "music") ?? UIImage(), likes: 150, comments: comments, shares: 15, suitableCategories: [categories[3]]),
        Post(postedBy: users[1], postedOn: Date(), length: 90, title: "Traveling to Paris", cover: UIImage(named: "paris") ?? UIImage(), likes: 100, comments: comments, shares: 10, suitableCategories: [categories[0]]),
        Post(postedBy: users[2], postedOn: Date(), length: 150, title: "My Favorite Recipes", cover: UIImage(named: "cooking") ?? UIImage(), likes: 180, comments: comments, shares: 18, suitableCategories: [categories[1]])
    ]
    
    // Assign liked and saved posts to users
    users[0].likedPosts.append(contentsOf: [posts[0], posts[2]])
    users[0].savedPosts.append(posts[1])
    users[1].likedPosts.append(posts[0])
    users[1].savedPosts.append(contentsOf: posts)
    users[2].likedPosts.append(contentsOf: [posts[1], posts[3]])
    users[2].savedPosts.append(posts[4])
    
    // Users following each other
    users[0].following.append(users[1])
    users[0].following.append(users[2])
    users[1].following.append(users[0])
    users[2].following.append(users[1])
    
    // Create dummy lives
    lives = [
        Live(postedBy: users[0], postedOn: Date(), beginsOn: Date().addingTimeInterval(3600), interested: users, title: "Live from Rome"),
        Live(postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(7200), interested: users, title: "Cooking Live"),
        Live(postedBy: users[2], postedOn: Date(), beginsOn: Date().addingTimeInterval(10800), interested: users, title: "Sports Live")
    ]
}
