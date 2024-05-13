//  DataController.swift
//  ElderTales
//
//  Created by student on 24/04/24.
//

import Foundation
import SwiftUI
//
//var users: [User] = []
//var posts: [Post] = []
//var lives: [Live] = []
//var categories: [Category] = []
import Foundation
import UIKit

class DataController {
    static let shared = DataController() // Singleton instance

    var users: [User] = []
    var posts: [Post] = []
    var lives: [Live] = []
    var comments: [Comment] = []
    var categories: [Category] = []
    var currentUser: User?

    private init() {
        loadFromDisk()
//        generateDummyData()
//        saveToDisk()
    }


    func toggleLikePost(postId: String) {
            guard currentUser != nil,
                  let postIndex = posts.firstIndex(where: { $0.id == postId }) else { return }

            let isLiked = currentUser!.likedPosts.contains(postId)
            if isLiked {
                currentUser!.likedPosts.removeAll { $0 == postId }
                posts[postIndex].likes -= 1
            } else {
                currentUser!.likedPosts.append(postId)
                posts[postIndex].likes += 1
            }
            saveToDisk()  // Assuming this function will handle saving state to disk
        }

    func toggleSavePost(postId: String) {
        guard currentUser != nil,
              let postIndex = posts.firstIndex(where: { $0.id == postId }) else { return }

        let isSaved = currentUser!.savedPosts.contains(postId)
        if isSaved {
            currentUser!.savedPosts.removeAll { $0 == postId }
        } else {
            currentUser!.savedPosts.append(postId)
        }
        saveToDisk()
    }

    func toggleFollowUser(userId: String) {
        guard currentUser != nil else { return }

        let isFollowing = currentUser!.following.contains(userId)
        if isFollowing {
            currentUser!.following.removeAll { $0 == userId }
        } else {
            currentUser!.following.append(userId)
        }
        saveToDisk()
    }

    // MARK: - Data Fetching

    func fetchPostsForCategory(_ categoryTitle: String) -> [Post] {
        return posts.filter { post in
            post.suitableCategories.contains(categoryTitle)
        }
    }

    func fetchPosts(postedBy: String) -> [Post] {
        return posts.filter { $0.postedBy == postedBy }
    }
    
    func fetchAllPosts() -> [Post] {
        return posts
    }
    
    func fetchPost(postId:String) -> Post?{
        return posts.first(where: {$0.id == postId}) ?? nil
    }
    func fetchUser(userId:String) -> User?{
        let user = users.first(where: {$0.id == userId}) ?? nil
        return user
    }
    
    func fetchLive(liveId:String) -> Live?{
        return lives.first(where: {$0.id == liveId}) ?? nil
    }
    
    func fetchCommentsForPost(post:Post) -> [Comment]{
        return comments.filter { $0.postId == post.id }
    }
    
    func fetchImage(imagePath:String?) -> UIImage?{
        let image = UIImage(contentsOfFile: imagePath ?? "") ?? UIImage(named: imagePath ?? "")
        return image
    }
    
    func fetchLives(postedBy:String) -> [Live]{
        return lives.filter { $0.postedBy == postedBy}
    }

    func fetchAllLives() -> [Live]{
        return lives
    }
    func newComment(post:Post, postedBy:User, body:String, isQuestion:Bool? = false){
        let newComment = Comment(postedBy: postedBy.id, postedOn: Date(), postId: post.id, body: body, isQuestion: isQuestion!)
        
        if let postIndex = posts.firstIndex(where: {$0.id == post.id}){
            posts[postIndex].comments.append(newComment.id)
        }
        comments.append(newComment)
        saveToDisk()
    }
    
    func addNewLive(live:Live){
        lives.insert(live, at: 0)
        saveToDisk()
    }
    
    func addNewPost(post:Post){
        posts.insert(post, at: 0)
        saveToDisk()
    }
    
    func getFollowersCount(userId:String) ->Int{
        let count = users.filter({ $0.following.contains(userId) }).count
        return  count
    }
    
    func getPostsCount(userId: String) -> Int {
        let count = posts.filter({ $0.postedBy == userId }).count
        return count
    }

    
    func updateUserDetails(name:String? = nil, email:String? = nil, description:String? = nil, imagePath:String? = nil){
        if let userIndex = users.firstIndex(where: {$0.id == currentUser!.id}){
            users[userIndex].name = name ?? currentUser!.name
            users[userIndex].email = email ?? currentUser!.email
            users[userIndex].description = description ?? currentUser!.description
            users[userIndex].image = imagePath ?? currentUser!.image
            currentUser = users[userIndex]
        }
        saveToDisk()
    }
    
    func endLive(liveId:String){
        let liveIndex = self.lives.firstIndex(where: {$0.id == liveId})
        if let liveIndex{
            lives[liveIndex].isFinished = true
        }
        saveToDisk()
    }
    
    func deleteLive(liveId:String){
        self.lives.removeAll(where: {$0.id == liveId})
        saveToDisk()
    }
    // MARK: - Persistence

    func saveToDisk() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        do {
            print("Saved to: " + filePath(for: "ElderTalesUsers").absoluteString)
            let encodedUsers = try encoder.encode(users)
            try encodedUsers.write(to: filePath(for: "ElderTalesUsers"), options: .atomic)

            let encodedPosts = try encoder.encode(posts)
            try encodedPosts.write(to: filePath(for: "ElderTalesPosts"), options: .atomic)

            let encodedLives = try encoder.encode(lives)
            try encodedLives.write(to: filePath(for: "ElderTalesLives"), options: .atomic)

            let encodedComments = try encoder.encode(comments)
            try encodedComments.write(to: filePath(for: "ElderTalesComments"), options: .atomic)

            let encodedCategories = try encoder.encode(categories)
            try encodedCategories.write(to: filePath(for: "ElderTalesCategories"), options: .atomic)
            
            let encodedCurrentUser = try encoder.encode(currentUser)
            try encodedCurrentUser.write(to: filePath(for: "ElderTalesCurrentUser"), options: .atomic)
        } catch {
            print("Failed to save data: \(error)")
        }
    }


    func loadFromDisk() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            print("Loading: " + filePath(for: "ElderTalesUsers").absoluteString)

            let userData = try Data(contentsOf: filePath(for: "ElderTalesUsers"))
            users = try decoder.decode([User].self, from: userData)

            let postData = try Data(contentsOf: filePath(for: "ElderTalesPosts"))
            posts = try decoder.decode([Post].self, from: postData)

            let liveData = try Data(contentsOf: filePath(for: "ElderTalesLives"))
            lives = try decoder.decode([Live].self, from: liveData)

            let commentData = try Data(contentsOf: filePath(for: "ElderTalesComments"))
            comments = try decoder.decode([Comment].self, from: commentData)

            let categoryData = try Data(contentsOf: filePath(for: "ElderTalesCategories"))
            categories = try decoder.decode([Category].self, from: categoryData)
            
            let currentUserData = try Data(contentsOf: filePath(for: "ElderTalesCurrentUser"))
            currentUser = try decoder.decode(User.self, from: currentUserData)
        } catch {
            print("Failed to load data: \(error)")
            generateDummyData()
        }
    }

    func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func filePath(for key: String) -> URL {
        return documentsDirectory().appendingPathComponent("\(key).json")
    }

    
    func generateDummyData() {
            // Initialize dummy categories with simple images stored by name
            categories = [
                Category(title: "Action", image: "elder.jpg"),
                Category(title: "Adventure", image: "Adventure"),
                Category(title: "Horror", image: "Horror"),
                Category(title: "Business", image: "Business")
            ]

            // Initialize dummy users
            users = [
                User(name: "Alice Smith", email: "alice@example.com", isElderly: true, password: "password123", image: "elder.jpg", description: "Hi, I am a passionate developer"),
                User(name: "Bob Johnson", email: "bob@example.com", isElderly: false, password: "password456", image: "youngster.jpg"),
                User(name: "Charlie Brown", email: "charlie@example.com", isElderly: false, password: "password789", image: "youngster.jpg")
            ]

            // Initialize dummy posts using user IDs and category references
            posts = [
                Post(postedBy: users[0].id, length: 120, title: "A Day in Rome", cover: "rome.jpg", link: "videoSong.mp4", hasVideo: true),
                Post(postedBy: users[1].id, length: 90, title: "Home Adventure Tips", cover: "adventure.jpg", link: "adventureVideo.mp4", hasVideo: true),
                Post(postedBy: users[2].id, length: 150, title: "My Favorite Sports Moments", cover: "sports.jpg", link: "sportsVideo.mp4", hasVideo: true)
            ]
        
        newComment(post: posts[0], postedBy: users[1], body: "Really enjoyed")
        newComment(post: posts[0], postedBy: users[1], body: "Really enjoyed")
        newComment(post: posts[1], postedBy: users[0], body: "Helpfull")
        newComment(post: posts[2], postedBy: users[2], body: "Really enjoyed")
        newComment(post: posts[2], postedBy: users[0], body: "Really enjoyed")

            // Assign liked and saved posts using post IDs
            users[0].likedPosts = [posts[0].id]
            posts[0].likePost(liked: true)
            users[0].savedPosts = [posts[1].id]
            posts[0].likePost(liked: true)

            // Initialize live events using user IDs
            lives = [
                Live(postedBy: users[0].id, postedOn: Date(), beginsOn: Date().addingTimeInterval(3600), title: "Live from Rome", isOngoing: false),
                Live(postedBy: users[1].id, postedOn: Date(), beginsOn: Date().addingTimeInterval(7200), title: "Adventure Live", isOngoing: false)
            ]

            // Assign current user
            currentUser = users[0]
        }
}

var dataController = DataController.shared
