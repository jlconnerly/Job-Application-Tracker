//
//  JobApplication+Extension.swift
//  Job Application Tracker
//
//  Created by Jake Connerly on 3/18/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation
import CoreData

enum ApplicationStatus: String, CaseIterable, Codable {
    case applied = "Applied"
    case receivedNo = "Received No"
    case underReview = "Under Review"
    case interviewOffered = "Interview Offered"
    case jobOffered = "Job Offered"
}

extension JobApplication {
    @discardableResult convenience init(company: String, appliedDate: Date, status: ApplicationStatus, jobTitle: String, identifier: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.company = company
        self.appliedDate = appliedDate
        self.status = status.rawValue
        self.jobTitle = jobTitle
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(jobApplicationRepresentation: JobApplicationRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let company = jobApplicationRepresentation.company,
            let appliedDate = jobApplicationRepresentation.appliedDate,
            let statusString = jobApplicationRepresentation.status,
            let status = ApplicationStatus(rawValue: statusString),
            let jobTitle = jobApplicationRepresentation.jobTitle,
            let identifier = jobApplicationRepresentation.identifier else { return nil }
        
        self.init(company: company, appliedDate: appliedDate, status: status, jobTitle: jobTitle, identifier: identifier)
    }
    
    var jobApplicationRepresentation: JobApplicationRepresentation {
        return JobApplicationRepresentation(company: company, appliedDate: appliedDate, jobTitle: jobTitle, status: status, identifier: identifier)
    }
}
