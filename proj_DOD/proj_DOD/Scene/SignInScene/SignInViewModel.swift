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
        var emailTextEvent: ControlProperty<String>
        var passwordTextEvent: ControlProperty<String>
        var signInButtonEvent: ControlEvent<Void>
        var signUpButtonEvent: ControlEvent<Void>
    }
    
    struct Output {
        var signInEnable: Driver<Bool>
        var signInResult: Driver<Bool>
        var moveToSignUp: Driver<Void>
    }
    
    internal func transform(input: Input) -> Output {
        
        let signInEnable = emitSignInButtonEnableEvent(emailTextEvent: input.emailTextEvent,
                                                       passwordTextEvent: input.passwordTextEvent)
        let signInResult = emitSignInResult(input.emailTextEvent,
                                            input.passwordTextEvent,
                                            input.signInButtonEvent)
        return Output(signInEnable: signInEnable,
                      signInResult: signInResult,
                      moveToSignUp: input.signUpButtonEvent.asDriver())
    }
    
    
    private func emitSignInButtonEnableEvent(
        emailTextEvent: ControlProperty<String>,
        passwordTextEvent: ControlProperty<String>
    ) -> Driver<Bool> {
        
        return Observable.combineLatest(emailTextEvent, passwordTextEvent) { (email, password) -> Bool in
            return !email.isEmpty && !password.isEmpty && email.isValidEmail
        }.asDriver(onErrorJustReturn: false)
    }
    
    private func emitSignInResult(
        _ emailTextEvent: ControlProperty<String>,
        _ passwordTextEvent: ControlProperty<String>,
        _ signInButtonEvent: ControlEvent<Void>
    ) -> Driver<Bool> {
        let zip = Observable.zip(emailTextEvent, passwordTextEvent)
        
        return signInButtonEvent.withLatestFrom(zip) { return $1 }
            .flatMap { [weak self] signInText -> Observable<Bool> in
                guard let strongSelf = self else { return Observable.just(false) }
                return strongSelf.requestSignIn(email: signInText.0, password: signInText.1)
            }.asDriver(onErrorJustReturn: false)
    }
    
    private func requestSignIn(email: String, password: String) -> Observable<Bool> {
        
        return Observable.just(false)
    }
    
}
