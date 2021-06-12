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
        var newPasswordDoubleCheck: Driver<Bool>

        var isAllValidInput: Driver<Bool>
        var resultSignUpEvent: Observable<Bool>
    }
    

    
    internal func transform(input: Input) -> Output {
        let emailValidationCheck = emitEventOfValidationEmail(input.emailTextEvent)
        
        let newPasswordDoubleCheck = emitEventOfPasswordDoubleCheck(input.newPasswordTextEvent,
                                                                    input.newPasswordCheckTextEvent)
        
        let isAllValidIntput = emitIsAllValidInputEvent(emailValidationCheck,
                                                        newPasswordDoubleCheck,
                                                        input.nicknameTextEvent)
        let resultSignUpEvent = emitSignUpResult(input.signUpButtonEvent,
                                                 input.emailTextEvent,
                                                 input.newPasswordTextEvent,
                                                 input.nicknameTextEvent)
        
        return Output(emailValidationCheck: emailValidationCheck,
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
    
    private func emitEventOfPasswordDoubleCheck(
        _ newPasswordTextEvent: ControlProperty<String>,
        _ newPasswordCheckTextEvent: ControlProperty<String>
    ) -> Driver<Bool> {
        let checkPassword = Observable.combineLatest(newPasswordTextEvent, newPasswordCheckTextEvent) {
            return $0 == $1
        }
        
        return checkPassword.asDriver(onErrorJustReturn: false)
    }
    
    private func emitIsAllValidInputEvent(
        _ emailValidationCheck: Driver<EmailValidationCheck>,
        _ newPasswordDoubleCheck: Driver<Bool>,
        _ nicknameTextEvent: ControlProperty<String>
    ) -> Driver<Bool> {
        
        return Driver.combineLatest(
            nicknameTextEvent.asDriver(),
            emailValidationCheck,
            newPasswordDoubleCheck
        ) { return !$0.isEmpty && $1 == .success && $2 }
        .asDriver(onErrorJustReturn: false)
    }
    
    private func emitSignUpResult(_ signUpButtonEvent: ControlEvent<Void>,
                                  _ emailTextEvent: ControlProperty<String>,
                                  _ newPasswordTextEvent: ControlProperty<String>,
                                  _ nicknameTextEvent: ControlProperty<String>) -> Observable<Bool> {
        
        let zip = Observable.zip(emailTextEvent, newPasswordTextEvent, nicknameTextEvent)
        
        
        return signUpButtonEvent.withLatestFrom(zip){ return $1 }
            .flatMap{ [weak self] signUpTexts -> Observable<Bool> in
                guard let strongSelf = self else { return Observable.just(false) }
                return strongSelf.requestSignUp(email: signUpTexts.0,
                                                password: signUpTexts.1,
                                                nickname: signUpTexts.2)
            }
    }
    
    private func requestSignUp(email: String, password: String, nickname: String) -> Observable<Bool> {
        return Observable.just(true).take(1)
    }
}
