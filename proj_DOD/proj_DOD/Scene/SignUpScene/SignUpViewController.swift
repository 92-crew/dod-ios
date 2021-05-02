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
        textField.keyboardType = .emailAddress
//        textField.
        textField.textContentType = .username
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private var emailDuplicateCheckLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.font = .systemFont(ofSize: 13, weight: .bold)
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
        textField.isSecureTextEntry = true
        textField.textContentType = .newPassword
        textField.autocorrectionType = .no
        textField.disableAutoFill()
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private var newPasswordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Check Password"
        textField.isSecureTextEntry = true
        textField.textContentType = .newPassword
        textField.autocorrectionType = .no
        textField.disableAutoFill()
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private var newPasswordCheckLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Password Check Success"
        label.textColor = .green
        label.font = .systemFont(ofSize: 13, weight: .bold)
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
        emailTextField.becomeFirstResponder()
        configureViewModel()
    }
    
    private func configureViewModel() {
        let input = SignUpViewModel.Input(
            emailEditingStartEvent: emailTextField.rx.controlEvent(.editingDidBegin),
            emailTextEvent: emailTextField.rx.text.orEmpty,
            emailEditingEndedEvent: emailTextField.rx.controlEvent(.editingDidEnd),
            
            newPasswordEditingStartEvent: newPasswordTextField.rx.controlEvent(.editingDidBegin),
            newPasswordTextEvent: newPasswordTextField.rx.text.orEmpty,
            newPasswordEditingEndedEvent: newPasswordTextField.rx.controlEvent(.editingDidEnd),
            
            newPasswordCheckEditingStartEvent: newPasswordCheckTextField.rx.controlEvent(.editingDidBegin),
            newPasswordCheckTextEvent: newPasswordCheckTextField.rx.text.orEmpty,
            newPasswordCheckEditingEndedEvent: newPasswordCheckTextField.rx.controlEvent(.editingDidEnd),
            
            nicknameEditingStartEvent: nicknameTextField.rx.controlEvent(.editingDidBegin),
            nicknameTextEvent: nicknameTextField.rx.text.orEmpty,
            nicknameEditingEndedEvent: nicknameTextField.rx.controlEvent(.editingDidEnd),
            signUpButtonEvent: signUpButton.rx.tap)
        

        let output = signUpViewModel.transform(input: input)
        
        bindEmailCheckEvent(output.emailValidationCheck)
        bindPasswordCheckEvent(output.newPasswordDoubleCheck)
        bindNewPasswordEditingStart(output.newPasswordEditingStart)
        bindNewPasswordCheckEditingStart(output.newPasswordCheckEditingStart)
        bindNicknameEditingStart(output.nicknameEditingStart)
        bindSignUpButtonEnabled(output.isAllValidInput)
        bindResultSignUpEvent(output.resultSignUpEvent)
        bindIsEditing(output.isEditing)
        
        
    }
    
    private func bindEmailCheckEvent(_ emailValidationCheck: Driver<EmailValidationCheck>) {
        emailValidationCheck.drive(onNext: { [weak self] check in
            guard let strongSelf = self else { return }
            
            switch check {
            case .nonEmailFormatError:
                strongSelf.emailDuplicateCheckLabel.textColor = .dodRed1
                strongSelf.emailDuplicateCheckLabel.isHidden = false
                strongSelf.emailDuplicateCheckLabel.text = "올바르지 않은 이메일 형식입니다."
            case .duplicatedCheckError:
                strongSelf.emailDuplicateCheckLabel.textColor = .dodRed1
                strongSelf.emailDuplicateCheckLabel.isHidden = false
                strongSelf.emailDuplicateCheckLabel.text = "중복된 이메일 입니다."
            case .success:
                strongSelf.emailDuplicateCheckLabel.textColor = .dodGreen1
                strongSelf.emailDuplicateCheckLabel.isHidden = false
                strongSelf.emailDuplicateCheckLabel.text = "사용 가능한 이메일입니다."
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindPasswordCheckEvent(_ newPasswordDoubleCheck: Driver<Bool>) {
        newPasswordDoubleCheck
            .drive(onNext: { [weak self] isCheck in
            guard let strongSelf = self else { return }
            if !isCheck {
                strongSelf.newPasswordCheckLabel.textColor = .dodRed1
                strongSelf.newPasswordCheckLabel.isHidden = false
                strongSelf.newPasswordCheckLabel.text = "비밀번호 입력을 확인하여 주세요"
            }
            else {
                strongSelf.newPasswordCheckLabel.isHidden = true
            }
            }).disposed(by: disposeBag)
    }
    
    private func bindNewPasswordEditingStart(_ newPasswordEditingStart: Driver<Void>) {
        newPasswordEditingStart.drive(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            
            let newPassWordTextFieldPoint = CGPoint(x: 0,
                                                    y: strongSelf.newPasswordTextField.frame.minY)
            strongSelf.inputScrollView.setContentOffset(newPassWordTextFieldPoint,
                                                        animated: true)
        }).disposed(by: disposeBag)
    }

    private func bindNewPasswordCheckEditingStart(_ newPasswordCheckEditingStart: Driver<Void>) {
        newPasswordCheckEditingStart.drive(onNext: { [weak self] in
            guard let strongSelf = self else { return }

            let newPasswordCheckTextFieldPoint = CGPoint(x: 0,
                                                         y: strongSelf.newPasswordCheckTextField.frame.minY)
            strongSelf.inputScrollView.setContentOffset(newPasswordCheckTextFieldPoint, animated: true)
        }).disposed(by: disposeBag)
    }

    private func bindNicknameEditingStart(_ nicknameEditingStart: Driver<Void>) {
        nicknameEditingStart.drive(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            
            let nicknameTextFieldPoint = CGPoint(x: 0,
                                                 y: strongSelf.nicknameTextField.frame.minY)
            strongSelf.inputScrollView.setContentOffset(nicknameTextFieldPoint,
                                                        animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func bindIsEditing(_ isEditing: Driver<Bool>) {
        isEditing.drive(onNext: { [weak self] isEditing in
            if isEditing {
                self?.inputScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
            }
            else {
                self?.inputScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindSignUpButtonEnabled(_ isAllValidInput: Driver<Bool>) {
        isAllValidInput.drive(onNext: { [weak self] isAllValid in
            guard let strongSelf = self else { return }
            
            strongSelf.setSignUpButton(isAllValid)
        }).disposed(by: disposeBag)
    }
    
    private func bindResultSignUpEvent(_ resultSignUpEvent: Observable<Bool>) {
        resultSignUpEvent.subscribe(onNext: { [weak self] result in
            guard let strongSelf = self else { return }
            if result {
                strongSelf.navigationController?.popViewController(animated: true)
            }
            else {
                strongSelf.simpleAlert(title: "로그인 실패", message: "아이디 또는 비밀번호를 확인해 주세요")
            }
        }).disposed(by: disposeBag)
    }
    
    private func setSignUpButton(_ isAllValid: Bool) {
        if isAllValid {
            signUpButton.backgroundColor = .dodRed1
            signUpButton.isEnabled = true
        }
        else {
            signUpButton.backgroundColor = .lightGray
            signUpButton.isEnabled = false
        }
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
