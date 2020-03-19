//
//  CurrentApplicationsViewController.swift
//  Job Application Tracker
//
//  Created by Jake Connerly on 3/18/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import UIKit

class CurrentApplicationsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        isFirstLaunchCheck()
    }
    
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

}

//extension CurrentApplicationsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//    
//    
//}
