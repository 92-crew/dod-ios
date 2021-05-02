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
    case nonEmailFormatError, duplicatedCheckError, success
    
    var errorMessage: String? {
        switch self {
        case .nonEmailFormatError:
            return "올바르지 않은 이메일 형식 입니다."
        case .duplicatedCheckError:
            return "중복된 이메일 입니다."
        default:
            return nil
        }
    }
}

class SignUpViewModel: ViewModelType {
    
    struct Input {
        var emailEditingStartEvent: ControlEvent<Void>
        var emailTextEvent: ControlProperty<String>
        var emailEditingEndedEvent: ControlEvent<Void>
        
        var newPasswordEditingStartEvent: ControlEvent<Void>
        var newPasswordTextEvent: ControlProperty<String>
        var newPasswordEditingEndedEvent: ControlEvent<Void>
        
        var newPasswordCheckEditingStartEvent: ControlEvent<Void>
        var newPasswordCheckTextEvent: ControlProperty<String>
        var newPasswordCheckEditingEndedEvent: ControlEvent<Void>
        
        var nicknameEditingStartEvent: ControlEvent<Void>
        var nicknameTextEvent: ControlProperty<String>
        var nicknameEditingEndedEvent: ControlEvent<Void>
        
        var signUpButtonEvent: ControlEvent<Void>
    }
    
    struct Output {
        var isEditing: Driver<Bool>
        var emailValidationCheck: Driver<EmailValidationCheck>
        var newPasswordEditingStart: Driver<Void>
        var newPasswordCheckEditingStart: Driver<Void>
        var newPasswordDoubleCheck: Driver<Bool>
        var nicknameEditingStart: Driver<Void>
        var nicknameEditingEnded: Driver<Void>
        var isAllValidInput: Driver<Bool>
        var resultSignUpEvent: Observable<Bool>
    }
    

    
    internal func transform(input: Input) -> Output {
        let emailValidationCheck = emitEventOfValidationEmail(input.emailTextEvent)
        
        let newPasswordDoubleCheck = emitEventOfPasswordDoubleCheck(input.newPasswordTextEvent,
                                                                    input.newPasswordCheckTextEvent,
                                                                    input.newPasswordCheckEditingEndedEvent)
        let isEditing = emitIsEditingEvent(input.emailEditingStartEvent,
                                           input.newPasswordEditingStartEvent,
                                           input.newPasswordCheckEditingStartEvent,
                                           input.nicknameEditingStartEvent,
                                           input.emailEditingEndedEvent,
                                           input.newPasswordCheckEditingEndedEvent,
                                           input.nicknameEditingEndedEvent)
        
        let isAllValidIntput = emitIsAllValidInputEvent(emailValidationCheck,
                                                        newPasswordDoubleCheck,
                                                        input.nicknameTextEvent)
        let resultSignUpEvent = emitSignUpResult(input.signUpButtonEvent,
                                                 input.emailTextEvent,
                                                 input.newPasswordTextEvent,
                                                 input.nicknameTextEvent)
        
        return Output(isEditing: isEditing,
                      emailValidationCheck: emailValidationCheck,
                      newPasswordEditingStart: input.newPasswordEditingStartEvent.asDriver(),
                      newPasswordCheckEditingStart: input.newPasswordCheckEditingStartEvent.asDriver(),
                      newPasswordDoubleCheck: newPasswordDoubleCheck,
                      nicknameEditingStart: input.nicknameEditingStartEvent.asDriver(),
                      nicknameEditingEnded: input.nicknameEditingEndedEvent.asDriver(),
                      isAllValidInput: isAllValidIntput,
                      resultSignUpEvent: resultSignUpEvent)
    }
    
    private func emitEventOfValidationEmail(
        _ emailTextEvent: ControlProperty<String>
    ) -> Driver<EmailValidationCheck> {
        
        return emailTextEvent
            .filter{ $0.count > 2 }
            .debounce(.seconds(1),
                      scheduler: MainScheduler.instance)
            .flatMap { [weak self] (email) -> Observable<EmailValidationCheck> in
                guard let strongSelf = self else {
                    return Observable.just(EmailValidationCheck.nonEmailFormatError)
                }
                
                return strongSelf.requestCheck(email)
            }.asDriver(onErrorJustReturn: .duplicatedCheckError)
        
    }
    
    private func requestCheck(_ email: String) -> Observable<EmailValidationCheck> {
        if !email.isValidEmail {
            return Observable.just(EmailValidationCheck.nonEmailFormatError)
        }
        
        return Observable.just(EmailValidationCheck.success)
    }
    
    private func emitEventOfPasswordDoubleCheck(
        _ newPasswordTextEvent: ControlProperty<String>,
        _ newPasswordCheckTextEvent: ControlProperty<String>,
        _ newPasswordCheckEditingEndedEvent: ControlEvent<Void>
    ) -> Driver<Bool> {
        let checkPassword = Observable.combineLatest(newPasswordTextEvent, newPasswordCheckTextEvent) {
            return $0 == $1
        }
        
        return checkPassword.asDriver(onErrorJustReturn: false)
    }
    
    private func emitIsEditingEvent(
        _ emailEditingStartEvent: ControlEvent<Void>,
        _ newPasswordEditingStartEvent: ControlEvent<Void>,
        _ newPasswordCheckEditingStartEvent: ControlEvent<Void>,
        _ nicknameEditingStartEvent: ControlEvent<Void>,
        _ emailEditingEndedEvent: ControlEvent<Void>,
        _ newPasswordCheckEditingEndedEvent: ControlEvent<Void>,
        _ nicknameEditingEndedEvent: ControlEvent<Void>
    ) -> Driver<Bool> {
        let startEditing = Observable.merge(emailEditingStartEvent.asObservable(),
                                            newPasswordEditingStartEvent.asObservable(),
                                            newPasswordCheckEditingStartEvent.asObservable(),
                                            nicknameEditingStartEvent.asObservable()).map{ return true }

        let endEditing = Observable
            .merge(emailEditingEndedEvent.asObservable(),
                   nicknameEditingEndedEvent.asObservable())
            .map{ return false }
        
        return Observable.merge(startEditing, endEditing).asDriver(onErrorJustReturn: false)
    }
    
    private func emitIsAllValidInputEvent(
        _ emailValidationCheck: Driver<EmailValidationCheck>,
        _ newPasswordDoubleCheck: Driver<Bool>,
        _ nicknameTextEvent: ControlProperty<String>
    ) -> Driver<Bool> {
        
        let isValidInput = Observable.combineLatest(emailValidationCheck.asObservable(),
                                                    newPasswordDoubleCheck.asObservable()) {
            return $0 == .success && $1
        }
        
        return Observable.combineLatest(nicknameTextEvent, isValidInput) {
            return !$0.isEmpty && $1
        }.asDriver(onErrorJustReturn: false)
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
