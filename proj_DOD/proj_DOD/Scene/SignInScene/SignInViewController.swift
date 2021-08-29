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

import KakaoSDKUser

class SignInViewController: UIViewController {
    // MARK:- UI Compoents
    private var cancelBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                        target: self,
                                        action: nil)
        barButton.tintColor = .dodNavy1
        return barButton
    }()
    
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .dodNavy1
        imageView.image = UIImage(named: "dodLogo1")
        return imageView
    }()
    private var sloganLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        label.text = "오늘의 할일"
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .dodNavy1
        return label
    }()
    
    private var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.alpha = 0
        return stackView
    }()
    
    private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .dodNavy1
        textField.placeholder = "E-mail"
        textField.keyboardType = .emailAddress
        textField.borderStyle = .none
        textField.addLeftPadding(left: 15)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        textField.setUnderLined()
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .dodNavy1
        textField.placeholder = "Password"
        textField.borderStyle = .none
        textField.addLeftPadding(left: 15)
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.setUnderLined()
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.makeRounded(cornerRadius: 15)
        button.alpha = 0
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("회원가입 하기", for: .normal)
        button.setTitleColor(.dodNavy1, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.alpha = 0
        return button
    }()
    
    private var logoImageViewTopConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var distanceWithBottomSafeArea: CGFloat = 0
    
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
        configureAnimation()
        initGestureRecognizer()
        cancelBarButton.rx.tap.asDriver()
            .drive(onNext: {
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        distanceWithBottomSafeArea = 82
        emailTextField.delegate = self
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
    
    
    // MARK:- Configure
    private func configureUI() {
        
        view.backgroundColor = .dodWhite1
        
        // navigation
        navigationController?.navigationBar.tintColor = .dodNavy1
        navigationItem.leftBarButtonItem = cancelBarButton
        setNavigationBarClear()
        
        // logoImageView
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 509/600)
        ])
        
        // sloganLabel
        view.addSubview(sloganLabel)
        NSLayoutConstraint.activate([
            sloganLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sloganLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor)
        ])
        
        // Input StackView
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(passwordTextField)
        view.addSubview(inputStackView)
        
        NSLayoutConstraint.activate([
            inputStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
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
            signUpButton.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor),
            signUpButton.widthAnchor.constraint(equalTo: signInButton.widthAnchor, multiplier: 1/3),
            signUpButton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
//        view.rx.tapGesture().asDriver()
//            .drive(onNext: { [weak self] _ in self?.view.endEditing(true) })
//            .disposed(by: disposeBag)
    }
    
    private func configureViewModel() {
        let input = SignInViewModel.Input(emailTextEvent: emailTextField.rx.text.orEmpty,
                                         passwordTextEvent: passwordTextField.rx.text.orEmpty,
                                         signInButtonEvent: signInButton.rx.tap,
                                         signUpButtonEvent: signUpButton.rx.tap)
        
        let output = signInViewModel.transform(input: input)

        bindSignInState(output.signInEnable)
        bindSignInResult(output.signInResult)
        output.moveToSignUp.drive(onNext: {
            let signUpVC = SignUpViewController()
            self.show(signUpVC, sender: nil)
        }).disposed(by: disposeBag)
    }
    
    private func configureAnimation() {
        let transform = CGAffineTransform(translationX: 0, y: 100)
        logoImageView.transform = transform
        UIView.animate(withDuration: 0.5,
                       delay: TimeInterval(1),
                       options: .curveEaseIn,
                       animations: {
                        self.logoImageView.transform = .identity
        }, completion: { _ in
            UIView.animate(withDuration: TimeInterval(0.5), delay: .zero, options: .curveEaseIn, animations: {
                self.inputStackView.alpha = 1
                self.sloganLabel.alpha = 1
                self.signInButton.alpha = 1
                self.signUpButton.alpha = 1
            })
        })
    }
    
    // MARK:- ViewModel Binding
    private func bindSignInState(_ signInEnable: Driver<Bool>) {
        signInEnable
            .drive(onNext: { [weak self] isEnable in
            self?.setSignInButtonState(isEnabled: isEnable)
        }).disposed(by: disposeBag)
    }
    
    private func bindSignInResult(_ signInResult: Observable<(Bool, String?)>) {
        
        signInResult
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (isSuccess, message) in
                if isSuccess {
                    if let mid = Int(message ?? "") {
                        AuthService.shared.loginSuccessHandler(memberId: mid) {
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                else {
                    if let errorMessage = message {
                        self?.simpleAlert(title: "에러", message: errorMessage)
                        return
                    }
                }
            
        } onError: { [weak self] error in
            self?.simpleAlert(title: "에러", message: error.localizedDescription)
        }.disposed(by: self.disposeBag)

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
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
            as? UInt else { return }
        
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue)?.cgRectValue {
            self.textEditingAnimate(isEditing: true,
                                    duration: duration,
                                    curve: .init(rawValue: curve),
                                    distance: keyboardSize.height - distanceWithBottomSafeArea)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
            as? UInt else { return }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                as? NSValue)?.cgRectValue {
            self.textEditingAnimate(isEditing: false,
                                    duration: duration,
                                    curve: .init(rawValue: curve),
                                    distance: keyboardSize.height - distanceWithBottomSafeArea)
        }
    }
    
    private func textEditingAnimate(
        isEditing: Bool,
        duration: Double,
        curve: UIView.AnimationOptions,
        distance: CGFloat
    ) {
        let distanceWithDirection = isEditing ? -distance : distance
        let moveY = CGAffineTransform(translationX: 0, y: distanceWithDirection)
        let moveYOfLogoImage = CGAffineTransform(translationX: 0, y: distanceWithDirection / 2)
        UIView.animate(withDuration: duration,
                       delay: .zero,
                       options: curve,
                       animations: {
                        self.logoImageView.transform = isEditing ? moveYOfLogoImage : .identity
                        self.sloganLabel.alpha = isEditing ? 0 : 1
                        self.inputStackView.transform = isEditing ? moveY : .identity
                        self.signInButton.transform = isEditing ? moveY : .identity
                       })
        
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
}

extension SignInViewController: UIGestureRecognizerDelegate {
    
    func initGestureRecognizer() {
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        view.addGestureRecognizer(textFieldTap)
    }
    
    // 다른 위치 탭했을 때 키보드 없어지는 코드
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: emailTextField))! || (touch.view?.isDescendant(of: passwordTextField))! {
            return false
        }
        return true
    }
}
