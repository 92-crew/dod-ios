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
        var emailTextEvent: ControlProperty<String>
        var emailEditingEndedEvent: ControlEvent<Void>
        
        var newPasswordEditingStartEvent: ControlEvent<Void>
        var newPasswordTextEvent: ControlProperty<String>
        var newPasswordCheckTextEvent: ControlProperty<String>
        var newPasswordCheckEditingEndedEvent: ControlEvent<Void>
        
        var nicknameEditingStartEvent: ControlEvent<Void>
        var nicknameTextEvent: ControlProperty<String>
        var nicknameEditingEndedEvent: ControlEvent<Void>
    }
    
    struct Output {
        var emailValidationCheck: Driver<EmailValidationCheck>
        var newPasswordEditingStart: Driver<Void>
        var newPasswordDoubleCheck: Driver<Bool>
        var nicknameEditingStart: Driver<Void>
        var nicknameEditingEnded: Driver<Void>
    }
    

    
    internal func transform(input: Input) -> Output {
        let emailValidationCheck = emitEventOfValidationEmail(input.emailTextEvent,
                                                              input.emailEditingEndedEvent)
        let newPasswordDoubleCheck = emitEventOfPasswordDoubleCheck(input.newPasswordTextEvent,
                                                                    input.newPasswordCheckTextEvent,
                                                                    input.newPasswordCheckEditingEndedEvent)
        return Output(emailValidationCheck: emailValidationCheck,
                      newPasswordEditingStart: input.newPasswordEditingStartEvent.asDriver(),
                      newPasswordDoubleCheck: newPasswordDoubleCheck,
                      nicknameEditingStart: input.nicknameEditingStartEvent.asDriver(),
                      nicknameEditingEnded: input.nicknameEditingEndedEvent.asDriver())
    }
    
    private func emitEventOfValidationEmail(
        _ emailTextEvent: ControlProperty<String>,
        _ emailEditingEndedEvent: ControlEvent<Void>
    ) -> Driver<EmailValidationCheck> {
        return emailEditingEndedEvent.withLatestFrom(emailTextEvent){ (_, email) in
            return email
        }.flatMap { [weak self] (email) -> Observable<EmailValidationCheck> in
            guard let strongSelf = self else { return Observable.just(EmailValidationCheck.nonEmailFormatError) }
            return strongSelf.requestCheck(email)
        }.asDriver(onErrorJustReturn: .duplicatedCheckError)
        
    }
    
    private func requestCheck(_ email: String) -> Observable<EmailValidationCheck> {
        if email.isValidEmail {
            return Observable.just(EmailValidationCheck.nonEmailFormatError)
        }
        
        return Observable.just(EmailValidationCheck.duplicatedCheckError)
    }
    
    private func emitEventOfPasswordDoubleCheck(
        _ newPasswordTextEvent: ControlProperty<String>,
        _ newPasswordCheckTextEvent: ControlProperty<String>,
        _ newPasswordCheckEditingEndedEvent: ControlEvent<Void>
    ) -> Driver<Bool> {
        let checkPassword = Observable.zip(newPasswordTextEvent, newPasswordCheckTextEvent).map {
            return $0.0 == $0.1
        }
        
        return newPasswordCheckEditingEndedEvent.withLatestFrom(checkPassword){
            return $1
        }.asDriver(onErrorJustReturn: false)
    }
    
}
