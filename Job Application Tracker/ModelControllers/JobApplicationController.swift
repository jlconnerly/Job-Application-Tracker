//
//  JobApplicationController.swift
//  Job Application Tracker
//
//  Created by Jake Connerly on 3/18/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class JobApplicationController {
    
    let baseURL = URL(string: "https://job-application-tracker-afdaa.firebaseio.com/")!
    let token = KeychainWrapper.standard.string(forKey: "userID")
    var ref: DatabaseReference = Database.database().reference()
    
    /*
     let company: String?
     let appliedDate: Date?
     let jobTitle: String?
     let status: String?
     let identifier: Int32?
     */
    
    // MARK: - CREATE Job Application
    func createJobApplication(with company: String, appliedDate: Date, jobTitle: String, status: ApplicationStatus, identifier: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let jobApplication = JobApplication(company: company, appliedDate: appliedDate, status: status, jobTitle: jobTitle, identifier: identifier)
            
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when creating new job application:\(error)")
            }
            put(jobApplication: jobApplication)
        }
    }
    
    // MARK: - Update Job Application
    func updateJobApplication(jobApplication: JobApplication, with company: String, appliedDate: Date, jobTitle: String, status: ApplicationStatus, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            jobApplication.company = company
            jobApplication.appliedDate = appliedDate
            jobApplication.jobTitle = jobTitle
            jobApplication.status = status.rawValue
        }
        
        do{
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving context when updating job application:\(error)")
        }
        put(jobApplication: jobApplication)
    }
    
    // MARK: - Update
    func update(jobApplication: JobApplication, with jobApplicationRepresentation: JobApplicationRepresentation) {
        jobApplication.company     = jobApplicationRepresentation.company
        jobApplication.appliedDate = jobApplicationRepresentation.appliedDate
        jobApplication.jobTitle    = jobApplicationRepresentation.jobTitle
        jobApplication.status      = jobApplicationRepresentation.status
        jobApplication.identifier  = jobApplicationRepresentation.identifier ?? 0
    }
    
    // MARK: - Delete
    func deleteJobApplication(jobApplication: JobApplication, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        deleteJobApplication(jobApplication: jobApplication)
        context.performAndWait {
            context.delete(jobApplication)
            
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("error saving context when deleting job application:\(error)")
            }
        }
    }
    
    //MARK: - PUT
    func put(jobApplication: JobApplication, completion: @escaping () -> Void = {}) {
        print("Token at JobApplicationController is: \(token)")
        guard let token = token else { return }
        
        let requestURL = baseURL.appendingPathComponent("users").appendingPathComponent(token).appendingPathComponent("jobApplcations").appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do{
            let jobApplicationData = try JSONEncoder().encode(jobApplication.jobApplicationRepresentation)
            request.httpBody = jobApplicationData
        } catch {
            NSLog("Error encoding job application representation:\(error)")
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing jobApplicationRep to server:\(error)")
                return
            }
            completion()
        }.resume()
        // Firebase implementation.  
        //ref.child("users").child(token).child("jobApplications").setValue(jobApplication)
    }
    
    //MARK: - Delete From Server
    func deleteJobApplicationFromServer(jobApplication: JobApplication, completion: @escaping () -> Void = {}) {
        guard let token = token else { return }
        ref.child("users").child(token).child("jobApplications").child("\(jobApplication.identifier)").removeValue()
        completion()
    }
    
    //MARK: - Fetch Single Job Application From Persistant Store
    func fetchSingleJobApplicationFromPersistantStore(identifier: Int32, context: NSManagedObjectContext) -> JobApplication? {
        
        let fetchRequest: NSFetchRequest<JobApplication> = JobApplication.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        var jobApplication: JobApplication? = nil
        context.performAndWait {
            do{
                jobApplication = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching job application with identifier \(identifier):\(error)")
                jobApplication = nil
            }
        }
        return jobApplication
     }
    
    //MARK: - Fetch All Job Applications From Server
    func fetchAllJobApplicationsFromServer(completion: @escaping () -> Void) {
        guard let token    = token else { return }
        let requestURL     = baseURL.appendingPathComponent("users").appendingPathComponent(token).appendingPathComponent("jobApplications").appendingPathExtension("json")
        var request        = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("error fetching all job applications:\(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("error GETing data from server:\(error)")
                completion()
                return
            }
            
            do{
                let jobAppDictionary = try JSONDecoder().decode([String: JobApplicationRepresentation].self, from: data)
                let jobAppArray      = jobAppDictionary.map({ $0.value })
                let moc              = CoreDataStack.shared.container.newBackgroundContext()
                
                #warning("IMPLEMENT UPDATEPERSISTENTSTORE")
//                self.updatePersistentStore(forTaskIn)
            } catch {
                NSLog("error decoding job applications:\(error)")
            }
            completion()
        }.resume()
    }
    /*
     left off trying to decide to change the nest ref for an jobApplication from a string to an int.  If using the FIREBASE METHOD, so far
     it seems that you HAVE to use a string as a child.  Where as if using native URLSession, you can have an int.
     
     let company: String?
     let appliedDate: Date?
     let jobTitle: String?
     let status: String?
     let identifier: Int32?
     */
    
    //MARK: - Update Persistent Store
    func updatePersistentStore(forTasksIn jobApplicationRepresentations: [JobApplicationRepresentation], for context: NSManagedObjectContext) {
        context.performAndWait {
            for jobAppRep in jobApplicationRepresentations {
                guard let identifier = jobAppRep.identifier else { continue }
                
                if let jobApplication = self.fetchSingleJobApplicationFromPersistantStore(identifier: identifier, context: context) {
                    jobApplication.company     = jobAppRep.company
                    jobApplication.appliedDate = jobAppRep.appliedDate
                    jobApplication.jobTitle    = jobAppRep.jobTitle
                    jobApplication.status      = jobAppRep.status
                    jobApplication.identifier  = jobAppRep.identifier ?? 0
                } else {
                    JobApplication(jobApplicationRepresentation: jobAppRep, context: context)
                }
            }
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
}
