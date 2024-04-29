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
var currentUser: User? = nil

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
        User(name: "Alice Smith", email: "alice@example.com", isElderly: false, password: "password123", image: UIImage(named: "profile1") ?? UIImage()),
        User(name: "Bob Johnson", email: "bob@example.com", isElderly: true, password: "password456", image: UIImage(named: "profile2") ?? UIImage()),
        User(name: "Charlie Brown", email: "charlie@example.com", isElderly: false, password: "password789", image: UIImage(named: "profile3") ?? UIImage())
    ]
    
    
    // Create dummy comments
    comments = [
        Comment(postedBy: users[0], postedOn: Date(), body: "Great post!"),
        Comment(postedBy: users[1], postedOn: Date(), body: "Really enjoyed this."),
        Comment(postedBy: users[2], postedOn: Date(), body: "Love this!")
    ]
    
    // Create dummy posts
    posts = [
        Post(postedBy: users[0], length: 120, title: "A Day in Rome", cover: UIImage(named: "rome") ?? UIImage(), link: "", hasVideo: true),
        Post(postedBy: users[1], length: 90, title: "Home Cooking Tips", cover: UIImage(named: "cooking") ?? UIImage(), link: "", hasVideo: true),
        Post(postedBy: users[2], length: 150, title: "My Favorite Sports Moments", cover: UIImage(named: "sports") ?? UIImage(), link: "", hasVideo: true),
        Post(postedBy: users[0], length: 120, title: "How to Play the Guitar", cover: UIImage(named: "music") ?? UIImage(), link: "", hasVideo: true),
        Post(postedBy: users[1], length: 90, title: "Traveling to Paris", cover: UIImage(named: "paris") ?? UIImage(), link: "", hasVideo: true),
        Post(postedBy: users[2], length: 150, title: "My Favorite Recipes", cover: UIImage(named: "cooking") ?? UIImage(), link: "", hasVideo: true),
        Post(postedBy: users[0], length: 120, title: "Exploring the World", cover: UIImage(named: "world") ?? UIImage(), link: "", hasVideo: true),
        Post(postedBy: users[1], length: 90, title: "Cooking for Beginners", cover: UIImage(named: "cooking") ?? UIImage(), link: "", hasVideo: true),
        Post(postedBy: users[2], length: 150, title: "My Favorite Sports Teams", cover: UIImage(named: "sports") ?? UIImage(), link: "", hasVideo: true),
        Post(postedBy: users[0], length: 120, title: "How to Play the Piano", cover: UIImage(named: "music") ?? UIImage(), link: "", hasVideo: true),
        Post(postedBy: users[1], length: 90, title: "Traveling to New York", cover: UIImage(named: "newyork") ?? UIImage(), link: "", hasVideo: true)
    ]
    
    // Assign liked and saved posts to users
    users[0].likePost(post: posts[0], liked: true)
    posts[0].likePost(liked: true)
    users[0].likePost(post: posts[2], liked: true)
    posts[2].likePost(liked: true)
    users[0].savePost(post: posts[1], saved: true)
    posts[1].likePost(liked: true)


    users[1].likePost(post: posts[0], liked: true)
    posts[0].likePost(liked: true)
    users[1].savePost(post: posts[0], saved: true)
    users[1].savePost(post: posts[1], saved: true)
    users[1].savePost(post: posts[2], saved: true)

    users[2].likePost(post: posts[1], liked: true)
    users[2].likePost(post: posts[3], liked: true)
    users[2].savePost(post: posts[4], saved: true)
    
    // Create dummy lives
    lives = [
        Live(postedBy: users[0], postedOn: Date(), beginsOn: Date().addingTimeInterval(3600), title: "Live from Rome"),
        Live(postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(7200), title: "Cooking Live"),
        Live(postedBy: users[2], postedOn: Date(), beginsOn: Date().addingTimeInterval(10800), title: "Sports Live")
    ]
    
    currentUser = users[0]
}
