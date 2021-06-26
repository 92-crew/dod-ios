//
//  SignUpViewModel.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/26.
//

import Foundation

import RxSwift
import RxCocoa

enum EmailValidationCheck {
    case nonEmailFormatError, success
    
    var errorMessage: String? {
        switch self {
        case .nonEmailFormatError:
            return "올바르지 않은 이메일 형식 입니다."
        default:
            return nil
        }
    }
}

enum PasswordValidationCheck {
    case nonPasswordFormat
    case nonMatchedCheckField
    case success
}

class SignUpViewModel: ViewModelType {
    
    struct Input {
        var emailTextEvent: ControlProperty<String>
        
        var newPasswordTextEvent: ControlProperty<String>
        var newPasswordCheckTextEvent: ControlProperty<String>
        
        var nicknameTextEvent: ControlProperty<String>
        
        var signUpButtonEvent: ControlEvent<Void>
    }
    
    struct Output {
        var emailValidationCheck: Driver<EmailValidationCheck>
        var passwordValidationCheck: Driver<Bool>
        var newPasswordDoubleCheck: Driver<Bool>
        var isAllValidInput: Driver<Bool>
        var resultSignUpEvent: Observable<(Bool, String?)>
    }
    

    
    internal func transform(input: Input) -> Output {
        let emailValidationCheck = emitEventOfValidationEmail(input.emailTextEvent)
        let passwordValidationCheck = emitEventOfValidationPassword(input.newPasswordTextEvent)
        let newPasswordDoubleCheck = emitEventOfPasswordDoubleCheck(input.newPasswordTextEvent,
                                                                    input.newPasswordCheckTextEvent)
        
        let isAllValidIntput = emitIsAllValidInputEvent(emailValidationCheck,
                                                        passwordValidationCheck,
                                                        newPasswordDoubleCheck)
        let resultSignUpEvent = emitSignUpResult(input.signUpButtonEvent,
                                                 input.emailTextEvent,
                                                 input.newPasswordTextEvent,
                                                 input.nicknameTextEvent)
        
        return Output(emailValidationCheck: emailValidationCheck,
                      passwordValidationCheck: passwordValidationCheck,
                      newPasswordDoubleCheck: newPasswordDoubleCheck,
                      isAllValidInput: isAllValidIntput,
                      resultSignUpEvent: resultSignUpEvent)
    }
    
    private func emitEventOfValidationEmail(
        _ emailTextEvent: ControlProperty<String>
) -> Driver<EmailValidationCheck> {
        
        return emailTextEvent
            .filter{ $0.count > 2 }
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map {
                if $0.isValidEmail { return .success }
                return .nonEmailFormatError
            }
            .asDriver(onErrorJustReturn: .nonEmailFormatError)
    }
    
    private func emitEventOfValidationPassword(
        _ newPasswordTextEvent: ControlProperty<String>
    ) -> Driver<Bool> {
        return newPasswordTextEvent
            .asDriver()
            .filter { !$0.isEmpty }

            .map { $0.isValidPasword }
    }
    
    private func emitEventOfPasswordDoubleCheck(
        _ newPasswordTextEvent: ControlProperty<String>,
        _ newPasswordCheckTextEvent: ControlProperty<String>
    ) -> Driver<Bool> {
        
        let checkPassword = Observable.combineLatest(
            newPasswordTextEvent.filter { !$0.isEmpty },
            newPasswordCheckTextEvent.filter { !$0.isEmpty }
        ) {
            return $0 == $1
        }
        
        return checkPassword.asDriver(onErrorJustReturn: false)
    }
    
    private func emitIsAllValidInputEvent(
        _ emailValidationCheck: Driver<EmailValidationCheck>,
        _ passwordValidationCheck: Driver<Bool>,
        _ newPasswordDoubleCheck: Driver<Bool>
    ) -> Driver<Bool> {
        
        return Driver.combineLatest(
            emailValidationCheck,
            passwordValidationCheck,
            newPasswordDoubleCheck
        ) { $0 == .success && $1 && $2 }
        .asDriver(onErrorJustReturn: false)
    }
    
    private func emitSignUpResult(_ signUpButtonEvent: ControlEvent<Void>,
                                  _ emailTextEvent: ControlProperty<String>,
                                  _ newPasswordTextEvent: ControlProperty<String>,
                                  _ nicknameTextEvent: ControlProperty<String>) -> Observable<(Bool, String?)> {
        
        let combine = Observable.combineLatest(
            emailTextEvent,
            newPasswordTextEvent,
            nicknameTextEvent.map { $0.isEmpty ? "example" : $0 }
        )
        
        
        return signUpButtonEvent.withLatestFrom(combine)
            .flatMap{ [weak self] signUpTexts -> Observable<(Bool, String?)> in
                guard let strongSelf = self else { return Observable.just((false, nil)) }
                return strongSelf.requestSignUp(email: signUpTexts.0,
                                                password: signUpTexts.1,
                                                nickname: signUpTexts.2)
            }
    }
    
    private func requestSignUp(email: String, password: String, nickname: String) -> Observable<(Bool, String?)> {
        return AuthService.shared.requestSignUp(email: email, name: nickname, password: password)
            .map { networkResult in
                switch networkResult {
                case .success(let data):
                    guard let signInResult = data as? SignInResult else {
                        return (false, nil)
                    }
                    return (true, "\(signInResult.id)")
                case .requestErr(let data):
                    guard let error = data as? ErrorResult else {
                        return (false, nil)
                    }
                    return (false, error.message)
                case .pathErr:
                    return (false, nil)
                case .serverErr:
                    return (false, "네트워크 연결이 불안정합니다.")
                case .networkFail:
                    return (false, "네트워크 연결이 불안정합니다.")
                }
            }
    }
}
