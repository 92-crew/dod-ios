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
        var signInResult: Observable<(Bool, String?)>
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
    ) -> Observable<(Bool, String?)> {
        let combine = Observable.combineLatest(emailTextEvent, passwordTextEvent)
        
        return signInButtonEvent.withLatestFrom(combine)
            .flatMap { [weak self] (email, password) -> Observable<(Bool, String?)> in
                guard let strongSelf = self else { return Observable.just((false, nil)) }
                return strongSelf.requestSignIn(email: email, password: password)
            }
    }
    
    private func requestSignIn(email: String, password: String) -> Observable<(Bool, String?)> {
        
        return AuthService.shared.requestSignIn(email: email, password: password)
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
