//
//  File.swift
//  ElderTales
//
//  Created by Student on 22/04/24.
//

import Foundation
import SwiftUI

struct User {
    var id: String
    var name: String
    var email: String
    var isElderly: Bool
    var password: String
    var image: UIImage?
    var likedPosts: [Post]
    var savedPosts: [Post]
    var following: [User]
    var interests: [Category]

    init(name: String, email: String, isElderly: Bool, password: String, image: UIImage? = nil) {
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
    }
    
    mutating func likePost(post: Post, liked: Bool) {
        if liked {
            // Add the post to the likedPosts array if it's not already there
            if !likedPosts.contains(where: { $0.id == post.id }) {
                likedPosts.append(post)
            }
        } else {
            // Remove the post from the likedPosts array if it's there
            likedPosts.removeAll { $0.id == post.id }
        }
    }
    
    mutating func savePost(post: Post, saved: Bool) {
        if saved {
            if !savedPosts.contains(where: { $0.id == post.id }) {
                savedPosts.append(post)
            }
        } else {
            // Remove the post from the savedPosts array if it's there
            savedPosts.removeAll { $0.id == post.id }
        }
    }
    
}

struct Post {
    var id: String
    var postedBy: User
    var postedOn: Date
    var length: Int
    var title: String
    var cover: UIImage
    var link: String
    var likes: Int
    var comments: [Comment]
    var shares: Int
    var hasVideo: Bool
    var suitableCategories: [Category]

    init(postedBy: User, length: Int, title: String, cover: UIImage, link: String, hasVideo: Bool) {
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
        self.suitableCategories = []
        self.hasVideo = hasVideo
    }
    
    mutating func likePost(liked: Bool){
        if liked {
            self.likes += 1
        } else {
            self.likes -= 1
        }
    }
}

struct Live {
    var id: String
    var postedBy: User
    var postedOn: Date
    var beginsOn: Date
    var interested: [User]
    var title: String

    init(postedBy: User, postedOn: Date, beginsOn: Date, title: String) {
        self.id = UUID().uuidString
        self.postedBy = postedBy
        self.postedOn = postedOn
        self.beginsOn = beginsOn
        self.title = title
        self.interested = []
    }
}

struct Comment {
    var postedBy: User
    var postedOn: Date
    var body: String

    init(postedBy: User, postedOn: Date, body: String) {
        self.postedBy = postedBy
        self.postedOn = postedOn
        self.body = body
    }
    
}

struct Category {
    var title: String
    var image: UIImage

    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }
    
}
