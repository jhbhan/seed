//
//  MainViewController.swift
//  seed.
//
//  Created by Jason Bhan on 7/25/20.
//  Copyright © 2020 ddevt. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController{
    let dummydata = [PostMetaData(author: "John", posttitle: "hello", postbody: "no", numLikes: 1, postid: "12345"),
                     PostMetaData(author: "Jay park", posttitle: "swag", postbody: "no", numLikes: 1,postid: "12345"),
                     PostMetaData(author: "Somi", posttitle: "yolo", postbody: "no", numLikes: 5,postid: "12345"),
                     PostMetaData(author: "momo", posttitle: "boooo", postbody: "no", numLikes: 9,postid: "12345"),
                     PostMetaData(author: "naruto", posttitle: "asdf", postbody: "no", numLikes: 123,postid: "12345")
    ]
    
    
    @IBOutlet var tableView: UITableView!
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = view.height/CGFloat(5)
        // Do any additional setup after loading the view.
        
    }
}

extension MainViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummydata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = dummydata[indexPath.row].author
        //cell.textLabel?.textAlignment = .center
        //cell.accessoryType = .detailButton
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //get post ID
        //get ALL of post metadata
        //navigate to the new post
    }
    
}
