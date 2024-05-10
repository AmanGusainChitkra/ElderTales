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
        Category(title: "Travel", image: UIImage(named: "travel") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Cooking", image: UIImage(named: "cooking") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Sports", image: UIImage(named: "sports") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Music", image: UIImage(named: "music") ?? UIImage(systemName: "person.fill") ?? UIImage()),Category(title: "Travel", image: UIImage(named: "travel") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Cooking", image: UIImage(named: "cooking") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Sports", image: UIImage(named: "sports") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Music", image: UIImage(named: "music") ?? UIImage(systemName: "person.fill") ?? UIImage()),Category(title: "Travel", image: UIImage(named: "travel") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Cooking", image: UIImage(named: "cooking") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Sports", image: UIImage(named: "sports") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Music", image: UIImage(named: "music") ?? UIImage(systemName: "person.fill") ?? UIImage()),Category(title: "Travel", image: UIImage(named: "travel") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Cooking", image: UIImage(named: "cooking") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Sports", image: UIImage(named: "sports") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Music", image: UIImage(named: "music") ?? UIImage(systemName: "person.fill") ?? UIImage()),Category(title: "Travel", image: UIImage(named: "travel") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Cooking", image: UIImage(named: "cooking") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Sports", image: UIImage(named: "sports") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Music", image: UIImage(named: "music") ?? UIImage(systemName: "person.fill") ?? UIImage()),Category(title: "Travel", image: UIImage(named: "travel") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Cooking", image: UIImage(named: "cooking") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Sports", image: UIImage(named: "sports") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Music", image: UIImage(named: "music") ?? UIImage(systemName: "person.fill") ?? UIImage()),Category(title: "Travel", image: UIImage(named: "travel") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Cooking", image: UIImage(named: "cooking") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Sports", image: UIImage(named: "sports") ?? UIImage(systemName: "person.fill") ?? UIImage()),
        Category(title: "Music", image: UIImage(named: "music") ?? UIImage(systemName: "person.fill") ?? UIImage())
    ]
    
        
        // Create dummy users
        users = [
            User(name: "Alice Smith", email: "alice@example.com", isElderly: false, password: "password123", image: UIImage(named: "profile1") ?? UIImage(), likedPosts: [], savedPosts: [], following: [], interests: categories),
            User(name: "Bob Johnson", email: "bob@example.com", isElderly: true, password: "password456", image: UIImage(named: "profile2") ?? UIImage(), likedPosts: [], savedPosts: [], following: [], interests: categories),
            User(name: "Bob Johnson", email: "bob@example.com", isElderly: true, password: "password456", image: UIImage(named: "profile2") ?? UIImage(), likedPosts: [], savedPosts: [], following: [], interests: categories),
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
        Live(title: "Exploring Ancient Temples", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(7200), interested: [users[2]]),
        Live(title: "Cooking Masterclass: Italian Cuisine", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(10800), interested: [users[3]]),
        Live(title: "Art Appreciation: Renaissance Paintings", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(14400), interested: [users[2]]),
        Live(title: "Historical Walk through Paris", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(18000), interested: [users[3]]),
        Live(title: "Virtual Tour of the Louvre Museum", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(21600), interested: [users[2]]),
        Live(title: "Gardening Tips for Beginners", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(25200), interested: [users[3]]),
        Live(title: "Book Club: Classic Literature", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(28800), interested: [users[2]]),
        Live(title: "Fitness for Seniors: Yoga and Meditation", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(32400), interested: [users[3]]),
        Live(title: "Q&A with a Historian: World War II", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(36000), interested: [users[2]]),
        Live(title: "Music Therapy Session: Relaxing Melodies", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(39600), interested: [users[3]]),
        Live(title: "Digital Photography Workshop", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(43200), interested: [users[2]]),
        Live(title: "Nature Sketching Class", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(46800), interested: [users[3]]),
        Live(title: "Mindfulness and Well-being Seminar", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(50400), interested: [users[2]]),
        Live(title: "Exploring Wildlife: Virtual Safari", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(54000), interested: [users[3]]),
        Live(title: "Travel Tales: Adventures in South America", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(57600), interested: [users[2]]),
        Live(title: "Healthy Cooking: Mediterranean Diet", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(61200), interested: [users[3]]),
        Live(title: "Language Exchange: Spanish Conversations", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(64800), interested: [users[2]]),
        Live(title: "Crafting Workshop: DIY Home Decor", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(68400), interested: [users[3]]),
        Live(title: "Tech Talk: Latest Gadgets and Trends", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(72000), interested: [users[2]]),
        Live(title: "History Trivia Night", postedBy: users[1], postedOn: Date(), beginsOn: Date().addingTimeInterval(75600), interested: [users[3]])
       
    ]
   
    }
