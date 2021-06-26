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
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.text = "안녕하세요\n처음 오셨군요."
        label.numberOfLines = 2
        return label
    }()
    
    private var totalInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        return stackView
    }()
    
    private var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        return stackView
    }()
    
    private var passwordInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        return stackView
    }()
    
    private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 0
        textField.placeholder = "example@example.com"
        textField.keyboardType = .emailAddress
        textField.disableAutoFill()
        textField.textContentType = .username
        textField.font = .systemFont(ofSize: 15)
        textField.setUnderLined()
        return textField
    }()
    
    private var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 1
        textField.placeholder = "닉네임(선택)"
        textField.font = .systemFont(ofSize: 15)
        textField.setUnderLined()
        return textField
    }()
    
    private var userInfoExplainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "설정하지 않는다면 기본값인 example 이 됩니다."
        label.textColor = .dodNavy1
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private var newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 2
        textField.placeholder = "새로운 비밀번호"
        textField.isSecureTextEntry = true
        textField.textContentType = .newPassword
        textField.autocorrectionType = .no
        textField.disableAutoFill()
        textField.font = .systemFont(ofSize: 15)
        textField.setUnderLined()
        return textField
    }()
    
    private var newPasswordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 3
        textField.placeholder = "비밀번호 재입력"
        textField.isSecureTextEntry = true
        textField.textContentType = .newPassword
        textField.autocorrectionType = .no
        textField.disableAutoFill()
        textField.font = .systemFont(ofSize: 15)
        textField.setUnderLined()
        return textField
    }()
    
    private var newPasswordCheckLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "비밀번호는 대문자/소문자/특수문자 포함, 8자 이상입니다."
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setTitle("회원가입 후 로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.makeRounded(cornerRadius: 23)
        button.backgroundColor = .lightGray
        return button
    }()
    
    private var totalInputStackViewBottomConstraint: NSLayoutConstraint!
    // MARK:- Fields
    var signUpViewModel = SignUpViewModel()
    var disposeBag = DisposeBag()
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        nicknameTextField.delegate = self
        newPasswordTextField.delegate = self
        newPasswordCheckTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)), name:
            UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            UIResponder.keyboardWillHideNotification, object: nil)
       }
    
    override func loadView() {
        super.loadView()
        configureUI()
        emailTextField.becomeFirstResponder()
        configureViewModel()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
            as? UInt else { return }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue)?.cgRectValue {
            let height = keyboardSize.height + signUpButton.frame.height + 10
            totalInputStackViewBottomConstraint.constant = -height
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: .init(rawValue: curve),
                           animations: {
                            self.signUpButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
                           })
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
            as? UInt else { return }
        totalInputStackViewBottomConstraint.constant = 0
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .init(rawValue: curve),
                       animations: { self.signUpButton.transform = .identity })
    }
    
    // MARK: - ViewModel Logic
    
    private func configureViewModel() {
        let input = SignUpViewModel.Input(
            emailTextEvent: emailTextField.rx.text.orEmpty,
            newPasswordTextEvent: newPasswordTextField.rx.text.orEmpty,
            newPasswordCheckTextEvent: newPasswordCheckTextField.rx.text.orEmpty,
            nicknameTextEvent: nicknameTextField.rx.text.orEmpty,
            signUpButtonEvent: signUpButton.rx.tap
        )
        

        let output = signUpViewModel.transform(input: input)
        
        bindEmailCheckEvent(output.emailValidationCheck)
        bindValidPasswordFormat(output.passwordValidationCheck)
        bindPasswordCheckEvent(output.newPasswordDoubleCheck)
        bindSignUpButtonEnabled(output.isAllValidInput)
        bindResultSignUpEvent(output.resultSignUpEvent)
    }
    
    private func bindEmailCheckEvent(_ emailValidationCheck: Driver<EmailValidationCheck>) {
        emailValidationCheck.drive(onNext: { [weak self] check in
            guard let strongSelf = self else { return }
            switch check {
            case .success:
                break
            case .nonEmailFormatError:
                break
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindValidPasswordFormat(_ passwordValidationCheck: Driver<Bool>) {
        passwordValidationCheck
            .drive(onNext: { [weak self] isValidFormat in
                guard let strongSelf =  self else { return }
                if !isValidFormat {
                    strongSelf.newPasswordCheckLabel.textColor = .dodRed1
                    strongSelf.newPasswordCheckLabel.isHidden = false
                    strongSelf.newPasswordCheckLabel.text = "비밀번호는 대문자/소문자/특수문자 포함, 8자 이상입니다."
                }
                else {
                    strongSelf.newPasswordCheckLabel.isHidden = true
                }
            }).disposed(by: self.disposeBag)
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
    
    private func bindSignUpButtonEnabled(_ isAllValidInput: Driver<Bool>) {
        isAllValidInput.drive(onNext: { [weak self] isAllValid in
            guard let strongSelf = self else { return }
            
            strongSelf.setSignUpButton(isAllValid)
        }).disposed(by: disposeBag)
    }
    
    private func bindResultSignUpEvent(_ resultSignUpEvent: Observable<(Bool, String?)>) {
        resultSignUpEvent.observe(on: MainScheduler.instance)
            .subscribe { [weak self] (isSuccess, message) in
                if isSuccess {
                    if let mid = Int(message ?? "") {
                        AuthService.shared.loginSuccessHandler(memberId: mid)
                    }
                    self?.dismiss(animated: true, completion: nil)
                    return
                }
                
                if let errorMessage = message {
                    self?.simpleAlert(title: "에러", message: errorMessage)
                    return
                }
                
        } onError: { [weak self] error in
            self?.simpleAlert(title: "에러", message: error.localizedDescription)
        }.disposed(by: self.disposeBag)
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
        configureUserInfoStackView()
        configurePasswordStackView()
        
        newPasswordTextField.rx.controlEvent([.editingDidBegin]).asDriver()
            .drive(onNext: { [weak self] in
                let point = CGPoint(x: 0, y: self?.newPasswordTextField.frame.minY ?? 0)
                self?.inputScrollView.setContentOffset(point, animated: true)
            }).disposed(by: disposeBag)
        newPasswordCheckTextField.rx.controlEvent([.editingDidBegin]).asDriver()
            .drive(onNext: { [weak self] in
                let point = CGPoint(x: 0, y: self?.newPasswordCheckTextField.frame.minY ?? 0)
                self?.inputScrollView.setContentOffset(point, animated: true)
            }).disposed(by: disposeBag)
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
    
            
        //SignUp Button
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 57),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureTotalStackView() {
        
        // Greeting label
        
        contentsView.addSubview(totalInputStackView)
        totalInputStackViewBottomConstraint = totalInputStackView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor)
        NSLayoutConstraint.activate([
            totalInputStackView.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 37),
            totalInputStackView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 35),
            totalInputStackView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -35),
            totalInputStackViewBottomConstraint
        ])
        
        totalInputStackView.addArrangedSubview(greetingLabel)
        totalInputStackView.addArrangedSubview(userInfoStackView)
        totalInputStackView.addArrangedSubview(passwordInputStackView)
        
    }
    
    private func configureUserInfoStackView() {
        
        userInfoStackView.addArrangedSubview(emailTextField)
        userInfoStackView.addArrangedSubview(nicknameTextField)
        userInfoStackView.addArrangedSubview(userInfoExplainLabel)
        
        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(equalToConstant: 45),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configurePasswordStackView() {
        // Input PasswordStackView
        passwordInputStackView.addArrangedSubview(newPasswordTextField)
        passwordInputStackView.addArrangedSubview(newPasswordCheckTextField)
        passwordInputStackView.addArrangedSubview(newPasswordCheckLabel)
        
        NSLayoutConstraint.activate([
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 45),
            newPasswordCheckTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            nicknameTextField.becomeFirstResponder()
        case nicknameTextField:
            newPasswordTextField.becomeFirstResponder()
        case newPasswordTextField:
            newPasswordCheckTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
}
