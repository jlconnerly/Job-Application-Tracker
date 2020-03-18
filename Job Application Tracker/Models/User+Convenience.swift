//
//  User+Extension.swift
//  Job Application Tracker
//
//  Created by Jake Connerly on 3/18/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation
import CoreData

extension User {
    @discardableResult convenience init(email: String, username: String, password: String, identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.email      = email
        self.username   = username
        self.password   = password
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.email      = userRepresentation.email
        self.username   = userRepresentation.username
        self.password   = userRepresentation.password
        self.identifier = userRepresentation.password
    }
    
    var userRepresentation: UserRepresentation {
        return UserRepresentation(email: email, username: username, password: password, identifier: identifier)
    }
}
