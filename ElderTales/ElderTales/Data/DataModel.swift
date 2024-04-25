//
//  File.swift
//  ElderTales
//
//  Created by Student on 22/04/24.
//

import Foundation
import SwiftUI

struct User {
    var name: String
    var email: String
    var isElderly: Bool
    var password: String
    var image: UIImage?
    var likedPosts: [Post]
    var savedPosts: [Post]
    var following: [User]
    var interests: [Category]
}

struct Post {
    var postedBy: User
    var postedOn: Date
    var length: Int
    var title: String
    var cover: UIImage
    var likes: Int
    var comments: [Comment]
    var shares: Int
    var suitableCategories: [Category]
}

struct Live{
    var title: String
    var postedBy: User
    var postedOn: Date
    var beginsOn: Date
    var interested: [User]
}

struct Comment {
    var postedBy: User
    var postedOn: Date
    var body: String
}

struct Category{
    var title: String
    var image: UIImage
}
