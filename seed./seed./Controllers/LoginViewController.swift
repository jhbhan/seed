//
//  LoginViewController.swift
//  seed.
//
//  Created by Jason Bhan on 7/25/20.
//  Copyright © 2020 ddevt. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import FBSDKLoginKit

class LoginViewController: UIViewController { 
    //loading button
    private let spinner = JGProgressHUD(style: .dark)
    
    //using scroll view in case our veritcal dimensions are shifted
    private let scrollView:UIScrollView={
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField:UITextField={
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor =  UIColor.lightGray.cgColor
        field.placeholder = "Email address..."
        field.leftView = UIView(frame: CGRect(x:0,y: 0,width: 5,height: 0))
        field.leftView?.backgroundColor = .white
        field.leftViewMode = .always
        return field
    }()
    
    private let passwordField:UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor =  UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x:0,y: 0,width: 5,height: 0))
        field.leftView?.backgroundColor = .white
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let fbloginButton = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //basic view UI
        title = "Log In"
        view.backgroundColor = .white
        
        //adds the register button on the top right of the screen
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        //adds all the view elements to the view itself
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(fbloginButton)
        
    }//EO viewDidLoad
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        
        loginButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        fbloginButton.frame = CGRect(x: 30,
                                     y: loginButton.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
    }//EO viewDidLayoutSubviews
    
    //when gister is tapped, change VC to RegisterViewController
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginButtonTapped(){
        guard let email = emailField.text,
            let password = passwordField.text,
            !email.isEmpty,
            !password.isEmpty
            else{
                alertUserLoginError(message: "Please enter your email and password")
                return
        }
        
    }
    
    func alertUserLoginError(message: String){
        let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",style: .cancel,handler: nil))
        present(alert,animated: true)
    }
}
