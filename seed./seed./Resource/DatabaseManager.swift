//
//  DatabaseManager.swift
//  seed.
//
//  Created by Jason Bhan on 7/29/20.
//  Copyright © 2020 ddevt. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    //so we only have once instead of it
    static let shared = DatabaseManager()
    //Database is a member of FirebaseDatabase
    private let database = Database.database().reference()
}

//extension for managing accounts

extension DatabaseManager{
    public func userExists(with email: String, completion: @escaping((Bool)->Void))
    {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        //see if it exists
        database.child("users").child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else {
                //returns false completion
                completion(false)
                return
            }
            //returns true completion
            completion(true)
        })
    }
    
    public func insertUser(with user: ChatAppUser){
        database.child("users").child(user.safeEmail).setValue(["first_name":user.firstName,
                                                                "last_name":user.lastName,
                                                                "survey_done": false])
        {
            //error handler
            (error: Error?, ref:DatabaseReference) in
            if let error = error {
                print("error in making user: \(error)")
            }
            else{
                print("user inserted in Firebase successfully")
            }
        }
    }
    
    //for the survey
    public func surveyFinished(with email: String){
        //grab the user key
        guard let key = database.child("users").child(email).key else {
            return
        }
        let update = ["/users/\(key)": ["survey_done":true]]
        database.updateChildValues(update)
    }
}

//post logic
extension DatabaseManager{
    private func getCurrentTime()->String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: now)
    }
    
    public func getTopPosts()->[PostMetaData]{
        let topposts = [PostMetaData]()
        //FIX ME
        return topposts
    }
    
    public func getNewPosts()->[PostMetaData]{
        let newposts = [PostMetaData]()
        //FIX ME
        return newposts
    }
    public func getFullPostData(with postid: String, completion: @escaping((Bool)->Void))->PostMetaData{
    
        let post = PostMetaData(author: "", posttitle: "", postbody: "", numLikes: 0, postid: "")
        //FIX ME
        return post
    }
    
    public func editPost(postid: String, newContent: String, completion: @escaping((Bool)->Void)){
        guard let key = database.child("posts").child(postid).key else {
            completion(false)
            return
        }
        let update = ["/posts/\(key)": ["content":newContent]]
        database.updateChildValues(update)
        {
            //error handler
            (error: Error?, ref:DatabaseReference) in
            if let error = error {
                print("error in updating post: \(error)")
                completion(false)
            }
            else{
                print("post updated successfully")
                completion(true)
            }
        }
    }
    
    public func addNewPost(post: PostMetaData, completion: @escaping((Bool)->Void)){
        database.child("posts").child(post.postid).setValue(
                ["author":post.author,
                 "title":post.posttitle,
                 "content": post.postbody,
                 "creationstamp": getCurrentTime(),
                 "upvotes":0,
                 "active":true]
                )
                {
                    //error handler
                    (error: Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("error in updating post: \(error)")
                        completion(false)
                    }
                    else{
                        print("post updated successfully")
                        completion(true)
                    }
                }
    }
    public func addComment(comment:CommentMetaData, completion: @escaping((Bool)->Void)){
        database.child("comments").child(comment.postid).child(comment.commentid).setValue(
                ["author":comment.author,
                 "content": comment.comment,
                 "creationstamp": getCurrentTime(),
                    "active":true]
                )
                {
                    //error handler
                    (error: Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("error in updating post: \(error)")
                        completion(false)
                    }
                    else{
                        print("post updated successfully")
                        completion(true)
                    }
                }
    }
    public func deletePost(with postid:String, completion: @escaping((Bool)->Void)){
        guard let key = database.child("posts").child(postid).key else {
            print("could not load key of the post")
            completion(false)
            return
        }
        let update = ["/posts/\(key)": ["active":true]]
        database.updateChildValues(update)
        {
            //error handler
            (error: Error?, ref:DatabaseReference) in
            if let error = error {
                print("error in deactivating post: \(error)")
                completion(false)
            }
            else{
                print("post deactivated successfully")
                completion(true)
            }
        }

    }
    public func deleteComment(with postid:String, commentid:String, completion : @escaping((Bool)->Void)){
        guard let key = database.child("comments").child(postid).child(commentid).key else {
            print("could not load key of the comment")
            completion(false)
            return
        }
        let update = ["/comment/\(postid)/\(key)": ["active":true]]
        database.updateChildValues(update)
        {
            //error handler
            (error: Error?, ref:DatabaseReference) in
            if let error = error {
                print("error in deactivating comment: \(error)")
                completion(false)
            }
            else{
                print("comment deactivated successfully")
                completion(true)
            }
        }
    }
    public func upvotePost(with postid:String){
        //FIX ME
    }
}

struct ChatAppUser{
    let firstName:String
    let lastName: String
    let emailAddress: String
    
    //converts email so it doesn't have @ and .
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

struct PostMetaData{
    let author:String
    let posttitle:String
    let postbody:String
    let numLikes:Int
    let postid:String
}

struct CommentMetaData{
    let postid:String
    let author:String
    let comment:String
    let commentid:String
}
