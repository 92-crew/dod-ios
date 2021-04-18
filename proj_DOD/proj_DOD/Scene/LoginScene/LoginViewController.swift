//
//  LoginViewController.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/19.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK:- UI Compoents
    var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .darkGray
        imageView.image = .checkmark
        return imageView
    }()
    
    var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .lightGray
        
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // MARK:- Life Cycle
    override func loadView() {
        super.loadView()
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        // logoImageView
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
        ])
        
        // Input StackView
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(passwordTextField)
        view.addSubview(inputStackView)
        
        NSLayoutConstraint.activate([
            inputStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 100),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100)
        ])
        
        // SignUpButton
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 20),
            signUpButton.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor, constant: -30),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Login Button
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            signInButton.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor, constant: 10),
            signInButton.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor, constant: -10),
            signInButton.heightAnchor.constraint(equalTo: signInButton.widthAnchor, multiplier: 1/3)
        ])
        
    }
}
