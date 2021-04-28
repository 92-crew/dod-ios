//
//  SignInViewController.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/19.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

class SignInViewController: UIViewController {
    // MARK:- UI Compoents
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .dodNavy1
        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()
    
    private var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .dodNavy1
        textField.placeholder = "E-mail"
        textField.borderStyle = .none
        textField.makeRounded(cornerRadius: 10)
        textField.setBorder(borderColor: .lightGray, borderWidth: 1)
        textField.addLeftPadding(left: 15)
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .dodNavy1
        textField.placeholder = "Password"
        textField.borderStyle = .none
        textField.makeRounded(cornerRadius: 10)
        textField.setBorder(borderColor: .lightGray, borderWidth: 1)
        textField.addLeftPadding(left: 15)
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.makeRounded(cornerRadius: 23)
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        return button
    }()
    
    // MARK:- Fields
    let signInViewModel: SignInViewModel = SignInViewModel()
    let disposeBag = DisposeBag()
    
    // MARK:- Life Cycle
    override func loadView() {
        super.loadView()
        configureUI()
        configureViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK:- Configure
    private func configureUI() {
        view.backgroundColor = .dodWhite1
        // navigation
        setNavigationBarShadow(color: .dodWhite1)
        navigationController?.navigationBar.tintColor = .dodNavy1
        // logoImageView
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
        ])
        
        // Input StackView
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(passwordTextField)
        view.addSubview(inputStackView)
        
        NSLayoutConstraint.activate([
            inputStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            inputStackView.heightAnchor.constraint(equalToConstant: 98)
        ])
        
        // SignIn Button
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 26),
            signInButton.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        setSignInButtonState(isEnabled: false)
        
        // SignUpButton
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 19),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 88),
            signUpButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func configureViewModel() {
        let input = SignInViewModel.Input(emailTextEvent: emailTextField.rx.text.orEmpty.asDriver(),
                                         passwordTextEvent: passwordTextField.rx.text.orEmpty.asDriver(),
                                         signInButtonEvent: signInButton.rx.tap.asDriver(),
                                         signUpButtonEvent: signUpButton.rx.tap.asDriver())
        
        emailTextField
            .rx
            .controlEvent([.editingDidEnd])
            .subscribe(onNext: { [weak self] in
                        self?.passwordTextField.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        let output = signInViewModel.transform(input: input)
        
        bindSignInState(output.signInEnable)
        bindSignInResult(output.signInResult)
        output.moveToSignUp.drive(onNext: {
            let signUpVC = SignUpViewController()
            self.show(signUpVC, sender: nil)
        }).disposed(by: disposeBag)
    }
    
    // MARK:- ViewModel Binding
    private func bindSignInState(_ signInEnable: Driver<Bool>) {
        signInEnable
            .drive(onNext: { [weak self] isEnable in
            self?.setSignInButtonState(isEnabled: isEnable)
        }).disposed(by: disposeBag)
    }
    
    private func bindSignInResult(_ signInResult: Driver<Bool>) {
        signInResult.drive(onNext: { [weak self] result in
            guard let strongSelf = self else { return }
            if result {
                
            }
            else {
                strongSelf.simpleAlert(title: "로그인 실패", message: "아이디 또는 비밀번호를 확인해 주세요")
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK:- UI Logic
    private func setSignInButtonState(isEnabled: Bool) {
        if isEnabled {
            signInButton.backgroundColor = .dodRed1
            signInButton.isEnabled = true
        }
        else {
            signInButton.backgroundColor = .lightGray
            signInButton.isEnabled = false
        }
    }
}
