//
//  UserRepresentation.swift
//  Job Application Tracker
//
//  Created by Jake Connerly on 3/18/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    var email: String?
    var username: String?
    var password: String?
    var identifier: String?
}

extension UserRepresentation: Equatable {
    static func == (lhs: UserRepresentation, rhs: User) -> Bool {
        return lhs.email == rhs.email &&
        lhs.username == rhs.username &&
        lhs.password == rhs.password &&
        lhs.identifier == rhs.identifier
    }
    
    static func == (lhs: User, rhs: UserRepresentation) -> Bool {
        return rhs == lhs
    }
    
    static func != (lhs: User, rhs: UserRepresentation) -> Bool {
        return rhs != lhs
    }
    
    static func != (lhs: UserRepresentation, rhs: User) -> Bool {
        return !(rhs == lhs)
    }
}
