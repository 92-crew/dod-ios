//
//  LoginViewModel.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/19.
//

import Foundation

import RxSwift
import RxCocoa


class SignInViewModel: ViewModelType {
    
    
    struct Input {
        var emailTextEvent: Driver<String>
        var passwordTextEvent: Driver<String>
        var signInButtonEvent: Driver<Void>
        var signUpButtonEvent: Driver<Void>
    }
    
    struct Output {
        var signInEnable: Driver<Bool>
        var signInResult: Driver<Bool>
        var moveToSignUp: Driver<Bool>
    }
    
    internal func transform(input: Input) -> Output {
        
        let signInEnable = emitSignInButtonEnableEvent(emailTextEvent: input.emailTextEvent,
                                                       passwordTextEvent: input.passwordTextEvent)
        let signInResult = input
            .signInButtonEvent
            .debounce(.milliseconds(1))
            .flatMap{
                return self.requestSignIn(emailTextEvent: input.emailTextEvent,
                                          passwordTextEvent: input.passwordTextEvent)
            }
        return Output(signInEnable: signInEnable, signInResult: signInResult, moveToSignUp: Driver.just(false))
    }
    
    
    private func emitSignInButtonEnableEvent(emailTextEvent: Driver<String>, passwordTextEvent: Driver<String>) -> Driver<Bool> {
        
        return Observable.combineLatest(emailTextEvent.asObservable(), passwordTextEvent.asObservable()) { (email, password) -> Bool in
            return !email.isEmpty && !password.isEmpty && email.isValidEmail
        }.asDriver(onErrorJustReturn: false)
    }
    
    private func requestSignIn(emailTextEvent: Driver<String>, passwordTextEvent: Driver<String>) -> Driver<Bool> {

        return Driver.just(false)
    }

}
