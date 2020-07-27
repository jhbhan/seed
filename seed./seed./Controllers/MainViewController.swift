//
//  MainViewController.swift
//  seed.
//
//  Created by Jason Bhan on 7/25/20.
//  Copyright © 2020 ddevt. All rights reserved.
//

import UIKit
import FirebaseAuth


class MainViewController: UIViewController {

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        //log in logic. check firebase auth if there is current user
        //if not, go to login controller
        //comment this block out to bypass it
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
