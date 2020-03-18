//
//  JobApplicationRepresentation.swift
//  Job Application Tracker
//
//  Created by Jake Connerly on 3/18/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation

struct JobApplicationRepresentation: Codable {
    let company: String?
    let appliedDate: Date?
    let jobTitle: String?
    let status: String?
    let identifier: Int32?
}

func ==(lhs: JobApplicationRepresentation, rhs: JobApplication) -> Bool {
    return lhs.company == rhs.company &&
        lhs.appliedDate == rhs.appliedDate &&
        lhs.jobTitle == rhs.jobTitle &&
        lhs.status == rhs.status &&
        lhs.identifier == rhs.identifier
}

func ==(lhs: JobApplication, rhs: JobApplicationRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: JobApplicationRepresentation, rhs: JobApplication) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: JobApplication, rhs: JobApplicationRepresentation) -> Bool {
    return rhs != lhs
}
