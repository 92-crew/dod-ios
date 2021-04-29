//
//  SignUpViewController.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/26.
//

import UIKit

import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    // MARK:- UI Components
    private var inputScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .dodWhite1
        return scrollView
    }()
    
    private var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .dodWhite1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var totalInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 34
        return stackView
    }()
    
    private var emailInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private var passwordInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private var nicknameInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "E-mail"
        label.textColor = .dodNavy1
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Input E-mail"
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private var emailDuplicateCheckLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Duplication Check Success"
        label.textColor = .green
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private var newPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New Password"
        label.textColor = .dodNavy1
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private var newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Input New Password"
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private var newPasswordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Check Password"
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private var newPasswordCheckLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Password Check Success"
        label.textColor = .green
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private var nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nickname"
        label.textColor = .dodNavy1
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Input Nickname"
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.makeRounded(cornerRadius: 23)
        button.backgroundColor = .lightGray
        return button
    }()
    
    // MARK:- Fields
    var signUpViewModel = SignUpViewModel()
    var disposeBag = DisposeBag()
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        configureUI()
    }
    
    private func configureViewModel() {
        let input = SignUpViewModel.Input(emailTextEvent: emailTextField.rx.text.orEmpty,
                                          emailEditingEndedEvent: emailTextField.rx.controlEvent(.editingDidEnd),
                                          newPasswordEditingStartEvent: newPasswordTextField.rx.controlEvent(.editingDidBegin),
                                          newPasswordTextEvent: newPasswordTextField.rx.text.orEmpty,
                                          newPasswordCheckTextEvent: newPasswordCheckTextField.rx.text.orEmpty,
                                          newPasswordCheckEditingEndedEvent: newPasswordCheckTextField.rx.controlEvent(.editingDidEnd),
                                          nicknameEditingStartEvent: nicknameTextField.rx.controlEvent(.editingDidBegin),
                                          nicknameTextEvent: nicknameTextField.rx.text.orEmpty,
                                          nicknameEditingEndedEvent: nicknameTextField.rx.controlEvent(.editingDidEnd))
        
        let output = signUpViewModel.transform(input: input)
        
    }
    
    

}

extension SignUpViewController {
    // MARK:- UI Method
    private func configureUI() {
        
        configureScrollView()
        configureTotalStackView()
        configureEmailStackView()
        configurePasswordStackView()
        configureNicknameStackView()
        
        //SignUp Button
        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 57)
        ])
        
    }
    
    private func configureScrollView() {
        // ScrollView
        view.addSubview(inputScrollView)
        
        NSLayoutConstraint.activate([
            inputScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            inputScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // ContentsView
        inputScrollView.addSubview(contentsView)
        
        NSLayoutConstraint.activate([
            contentsView.topAnchor.constraint(equalTo: inputScrollView.topAnchor),
            contentsView.leadingAnchor.constraint(equalTo: inputScrollView.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: inputScrollView.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: inputScrollView.bottomAnchor),
            contentsView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        let contentsHeightConstraint = contentsView.heightAnchor.constraint(equalTo: view.heightAnchor)
        contentsHeightConstraint.priority = .defaultLow
        contentsHeightConstraint.isActive = true
    }
    
    private func configureTotalStackView() {
        contentsView.addSubview(totalInputStackView)
        
        NSLayoutConstraint.activate([
            totalInputStackView.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 37),
            totalInputStackView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 28),
            totalInputStackView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -28),
            totalInputStackView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor)
        ])
        
        totalInputStackView.addArrangedSubview(emailInputStackView)
        totalInputStackView.addArrangedSubview(passwordInputStackView)
        totalInputStackView.addArrangedSubview(nicknameInputStackView)
        totalInputStackView.addArrangedSubview(signUpButton)
    }
    
    private func configureEmailStackView() {
        emailInputStackView.addArrangedSubview(emailLabel)
        emailInputStackView.addArrangedSubview(emailTextField)
        emailInputStackView.addArrangedSubview(emailDuplicateCheckLabel)
        
        NSLayoutConstraint.activate([
            emailLabel.heightAnchor.constraint(equalToConstant: 30),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),
            emailDuplicateCheckLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        emailTextField.makeRounded(cornerRadius: 10)
        emailTextField.setBorder(borderColor: .lightGray, borderWidth: 1)
        emailTextField.addLeftPadding(left: 15)
    }
    
    private func configurePasswordStackView() {
        // Input PasswordStackView
        passwordInputStackView.addArrangedSubview(newPasswordLabel)
        passwordInputStackView.addArrangedSubview(newPasswordTextField)
        passwordInputStackView.addArrangedSubview(newPasswordCheckTextField)
        passwordInputStackView.addArrangedSubview(newPasswordCheckLabel)
        
        NSLayoutConstraint.activate([
            newPasswordLabel.heightAnchor.constraint(equalToConstant: 30),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 45),
            newPasswordCheckTextField.heightAnchor.constraint(equalToConstant: 45),
            newPasswordCheckLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        newPasswordTextField.makeRounded(cornerRadius: 10)
        newPasswordTextField.setBorder(borderColor: .lightGray, borderWidth: 1)
        newPasswordTextField.addLeftPadding(left: 15)
        
        newPasswordCheckTextField.makeRounded(cornerRadius: 10)
        newPasswordCheckTextField.setBorder(borderColor: .lightGray, borderWidth: 1)
        newPasswordCheckTextField.addLeftPadding(left: 15)
    }
    
    private func configureNicknameStackView() {
        // Input nicknameStackView
        nicknameInputStackView.addArrangedSubview(nicknameLabel)
        nicknameInputStackView.addArrangedSubview(nicknameTextField)
        
        NSLayoutConstraint.activate([
            nicknameLabel.heightAnchor.constraint(equalToConstant: 30),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        nicknameTextField.makeRounded(cornerRadius: 10)
        nicknameTextField.setBorder(borderColor: .lightGray, borderWidth: 1)
        nicknameTextField.addLeftPadding(left: 15)
    }
}
