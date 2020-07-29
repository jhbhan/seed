//
//  RegisterViewController.swift
//  seed.
//
//  Created by Jason Bhan on 7/25/20.
//  Copyright © 2020 ddevt. All rights reserved.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class RegisterViewController: UIViewController {

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
    
    private let firstNameField:UITextField={
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor =  UIColor.lightGray.cgColor
        field.placeholder = "First Name..."
        field.leftView = UIView(frame: CGRect(x:0,y: 0,width: 5,height: 0))
        field.leftView?.backgroundColor = .white
        field.leftViewMode = .always
        return field
    }()
    
    private let lastNameField:UITextField={
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor =  UIColor.lightGray.cgColor
        field.placeholder = "Last Name..."
        field.leftView = UIView(frame: CGRect(x:0,y: 0,width: 5,height: 0))
        field.leftView?.backgroundColor = .white
        field.leftViewMode = .always
        return field
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
        field.returnKeyType = .continue
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
    
    
    private let passwordConfirmField:UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor =  UIColor.lightGray.cgColor
        field.placeholder = "Confirm Password..."
        field.leftView = UIView(frame: CGRect(x:0,y: 0,width: 5,height: 0))
        field.leftView?.backgroundColor = .white
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton:UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        //adds an action to the button
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        passwordConfirmField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(passwordConfirmField)
        scrollView.addSubview(registerButton)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        firstNameField.frame = CGRect(x: 30,
                                      y: imageView.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        
        passwordConfirmField.frame = CGRect(x: 30,
                                            y: passwordField.bottom+10,
                                            width: scrollView.width-60,
                                            height: 52)
        registerButton.frame = CGRect(x: 30,
                                      y: passwordConfirmField.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
        
    }
    
    @objc private func registerButtonTapped(){
        
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordConfirmField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let firstname = firstNameField.text,
        let lastname = lastNameField.text,
        let email = emailField.text,
        let password = passwordField.text,
        let passwordConfirm = passwordConfirmField.text,
            !firstname.isEmpty,!lastname.isEmpty,!email.isEmpty,!password.isEmpty,!passwordConfirm.isEmpty, password.count >= 6 else{
                alertUserRegisterError(message: "Please enter all information in order to register")
                return
        }
        
        if(password != passwordConfirm){
            alertUserRegisterError(message: "Your passwords do not match")
            passwordConfirmField.text = ""
            return
        }
        
        spinner.show(in: view)
        
        //Firebase Create Account
        
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            //if user already exists
            guard !exists else {
                strongSelf.alertUserRegisterError(message: "An account with this email already exists")
                return
            }
            
            //create Firebase user
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                
                guard authResult != nil, error == nil else{
                    print("Error creating user")
                    return
                }
                //if user was successsfully created, also insertUser into the database
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstname,
                                                                    lastName: lastname,
                                                                    emailAddress: email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
            })//Firebase createUser completion handler

        })//userExists completion handler
        
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/3
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func alertUserRegisterError(message: String){
        let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",style: .cancel,handler: nil))
        present(alert,animated: true)
    }

}


//sets up RegisterViewController as Delegate in UITextField
extension RegisterViewController: UITextFieldDelegate {
    //actions when pressing return on textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //next field becomes the responder
        if textField == firstNameField{
            lastNameField.becomeFirstResponder()
        }
        else if textField == lastNameField{
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField{
            passwordConfirmField.becomeFirstResponder()
        }
        else if textField == passwordConfirmField{
            registerButtonTapped()
        }
        return true
    }
}
