//
//  File.swift
//  ElderTales
//
//  Created by Student on 22/04/24.
//

import Foundation
import SwiftUI

struct User: Codable {
    var id: String
    var name: String
    var email: String
    var isElderly: Bool
    var password: String
    var image: String?  // Use base64 string or URL/path
    var likedPosts: [String]  // Array of post IDs
    var savedPosts: [String]  // Array of post IDs
    var following: [String]  // Array of user IDs
    var interests: [String]  // Array of category titles or IDs
    var description: String

    init(name: String, email: String, isElderly: Bool, password: String, image: String? = nil, description: String? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.email = email
        self.isElderly = isElderly
        self.password = password
        self.image = image
        self.likedPosts = []
        self.savedPosts = []
        self.following = []
        self.interests = []
        self.description = description ?? ""
    }
    
    mutating func likePost(postId: String, liked: Bool) {
        if liked {
            if !likedPosts.contains(postId) {
                likedPosts.append(postId)
            }
        } else {
            likedPosts.removeAll { $0 == postId }
        }
    }
    
    mutating func savePost(postId: String, saved: Bool) {
        if saved {
            if !savedPosts.contains(postId) {
                savedPosts.append(postId)
            }
        } else {
            savedPosts.removeAll { $0 == postId }
        }
    }
}


struct Post:Codable {
    var id: String
    var postedBy: String  // User ID
    var postedOn: Date
    var length: Int
    var title: String
    var cover: String  // Path or base64 string
    var link: String
    var likes: Int
    var comments: [String]  // Array of comment IDs
    var shares: Int
    var hasVideo: Bool
    var suitableCategories: [String]  // Array of category IDs or titles

    init(postedBy: String, length: Int, title: String, cover: String, link: String, hasVideo: Bool, suitableCategories:String? = nil) {
        self.id = UUID().uuidString
        self.postedBy = postedBy
        self.postedOn = Date()
        self.length = length
        self.title = title
        self.cover = cover
        self.link = link
        self.likes = 0
        self.comments = []
        self.shares = 0
        self.hasVideo = hasVideo
        self.suitableCategories = []
        if let suitableCategory = suitableCategories{
            self.suitableCategories.append(suitableCategory)
        }
    }
    
    mutating func likePost(liked: Bool){
        if liked {
            self.likes += 1
        } else {
            self.likes -= 1
        }
    }
}

struct Live:Codable {
    var id: String
    var postedBy: String  // User ID
    var postedOn: Date
    var beginsOn: Date
    var interested: [String]  // Array of user IDs
    var title: String
    var isOngoing: Bool
    var isFinished: Bool

    init(postedBy: String, postedOn: Date, beginsOn: Date, title: String, isOngoing:Bool? = false) {
        self.id = UUID().uuidString
        self.postedBy = postedBy
        self.postedOn = postedOn
        self.beginsOn = beginsOn
        self.title = title
        self.interested = []
        self.isOngoing = isOngoing!
        self.isFinished = false
    }
}

struct Comment:Codable {
    var id: String
    var postedBy: String  // User ID
    var postedOn: Date
    var body: String
    var postId:String
    var isQuestion: Bool

    init(postedBy: String, postedOn: Date, postId:String, body: String, isQuestion: Bool) {
        self.id = UUID().uuidString
        self.postedBy = postedBy
        self.postedOn = postedOn
        self.body = body
        self.isQuestion = isQuestion
        self.postId = postId
    }
    
}

struct Category:Codable {
    var title: String
    var image: String  // Path or base64 string

    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
}
