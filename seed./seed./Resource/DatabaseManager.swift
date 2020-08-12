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
        database.child("users").child(user.safeEmail).setValue(
            ["first_name":user.firstName,
            "last_name":user.lastName,
            "survey_done": false]
            )
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
    public func getTopPosts(){
        
    }
    
    public func getNewPosts(){
        
    }
    public func getFullPostData(with postid: String){
        
    }
    public func addNewPost(with post: PostMetaData){
        
    }
    public func addComment(with comment:CommentMetaData){
        
    }
    public func deletePost(with postid:String){
        
    }
    public func deleteComment(with postid:String, commentid:String){
        
    }
    public func upvotePost(with postid:String){
        
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
