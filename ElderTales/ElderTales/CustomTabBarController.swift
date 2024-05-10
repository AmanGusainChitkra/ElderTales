//
//  CustomTabBarController.swift
//  ElderTales
//
//  Created by student on 09/05/24.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateDummyData()
        configureTabsBasedOnUserRole()
    }
    
    private func configureTabsBasedOnUserRole() {
//        guard let user = fetchCurrentUser() else { return }

        if !(currentUser!.isElderly) {
            var viewControllers = self.viewControllers
            viewControllers?.remove(at: 2) // Assuming "Add New" tab is at index 2
            self.viewControllers = viewControllers
        }
    }
    
//    func fetchCurrentUser() -> User? {
//        // Implement the logic to fetch the current user
//        // For example, from a user session manager
//        return UserManager.shared.currentUser
//    }
    
}
