//
//  UserController.swift
//  Job Application Tracker
//
//  Created by Jake Connerly on 3/18/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class UserController {
    var user: UserRepresentation?
    var token: String?
    
    let baseURL = URL(string: "https://job-application-tracker-afdaa.firebaseio.com/")!
    
    func signUpWithEmail(email: String, username: String, password: String, completion: @escaping () -> Void = { }) {
        let ref: DatabaseReference?
        ref = Database.database().reference()
        
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if let error = error {
                NSLog("Error creating user:\(error)")
                completion()
                return
            }
            
            DispatchQueue.main.async {
                guard let firebaseUser = Auth.auth().currentUser else { return }
                ref?.child("users").child(firebaseUser.uid).setValue(["email": firebaseUser.email, "username": username])
                
                self.user = UserRepresentation(email: firebaseUser.email, username: username, password: password, identifier: firebaseUser.uid)
                
                do {
                    let context = CoreDataStack.shared.mainContext
                    context.performAndWait {
                        User(userRepresentation: self.user!)
                    }
                    try CoreDataStack.shared.save()
                    completion()
                } catch {
                    NSLog("error saving user to CoreData:\(error)")
                    completion()
                    return
                }
                self.signInWithEmail(email: email, password: password)
            }
        }
    }
    
    func signInWithEmail(email: String, password: String, completion: @escaping () -> Void = { }) {
        Auth.auth().signIn(withEmail: email, password: password) { (firebaseUser, error) in
            if let error = error {
                NSLog("Error signing in:\(error)")
                completion()
                return
            }
            print("Sign In Successful")
            DispatchQueue.main.async {
                guard let firebaseUser = Auth.auth().currentUser else { return }
                self.user = UserRepresentation(email: firebaseUser.email, username: firebaseUser.displayName, password: password, identifier: firebaseUser.uid)
                let context = CoreDataStack.shared.mainContext
                do{
                    context.performAndWait {
                        User(userRepresentation: self.user!)
                    }
                    try CoreDataStack.shared.save()
                    completion()
                } catch {
                    NSLog("Error saving user to coredate on sign in:\(error)")
                    completion()
                    return
                }
            }
        }
        completion()
    }
}
