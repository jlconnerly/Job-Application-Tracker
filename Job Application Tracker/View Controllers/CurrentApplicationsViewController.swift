//
//  CurrentApplicationsViewController.swift
//  Job Application Tracker
//
//  Created by Jake Connerly on 3/18/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import UIKit
import CoreData

class CurrentApplicationsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    let userController = UserController()
    let token: String? = KeychainWrapper.standard.string(forKey: "token")
    
    var user: UserRepresentation {
        let moc = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try moc.fetch(request)
            if let user = users.first {
                return user.userRepresentation
            }
        } catch {
            fatalError("Error performing fetch for user: \(error)")
        }
        return UserRepresentation()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<JobApplication> = {
        let fetchRequest: NSFetchRequest<JobApplication> = JobApplication.fetchRequest()
        
        // FRCs need at least one sort descriptor. If you are using "sectionNameKeyPath", the first sort descriptor must be the same attribute
        let dateDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        isFirstLaunchCheck()
    }
    
    //MARK: - Methods
    
    private func isFirstLaunchCheck() {
        if UserDefaults.isFirstLaunch() == true || userController.user == nil {
            performSegue(withIdentifier: "SignInSegue", sender: self)
        }
    }
    
    func configureNavigationBar() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.grayText]
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.grayText]
            navBarAppearance.backgroundColor = .mainBlue
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = .grayText
            //navigationItem.title = title
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = .mainBlue
            navigationController?.navigationBar.tintColor = .grayText
            navigationController?.navigationBar.isTranslucent = false
            //navigationItem.title = title
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            guard let signInVC = segue.destination as? SignUpSignInViewController else { return }
            signInVC.userController = userController
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    private var sectionChanges = [(type: NSFetchedResultsChangeType, sectionIndex: Int)]()
    private var itemChanges = [(type: NSFetchedResultsChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?)]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        sectionChanges.append((type, sectionIndex))
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        itemChanges.append((type, indexPath, newIndexPath))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        collectionView?.performBatchUpdates({
            
            for change in self.sectionChanges {
                switch change.type {
                case .insert: self.collectionView?.insertSections([change.sectionIndex])
                case .delete: self.collectionView?.deleteSections([change.sectionIndex])
                default: break
                }
            }
            
            for change in self.itemChanges {
                switch change.type {
                case .insert: self.collectionView?.insertItems(at: [change.newIndexPath!])
                case .delete: self.collectionView?.deleteItems(at: [change.indexPath!])
                case .update: self.collectionView?.reloadItems(at: [change.indexPath!])
                case .move:
                    self.collectionView?.deleteItems(at: [change.indexPath!])
                    self.collectionView?.insertItems(at: [change.newIndexPath!])
                @unknown default:
                    fatalError()
                }
            }
            
            self.sectionChanges.removeAll()
            self.itemChanges.removeAll()
            
        }, completion: { finished in
            // moved section and item changes from here
        })
    }
    
}

// MARK: - Extensions

extension CurrentApplicationsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobApplicationCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        cell.jobApplication = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
}

