//
//  AppStepper.swift
//  PetApp
//
//  Created by Artur Imanbaev on 20.09.2023.
//

import Foundation
import RxFlow
import RxSwift
import RxRelay

class AppStepper: Stepper{
    
    let disposeBag = DisposeBag()
    
    var steps = PublishRelay<Step>()
    
    var initialStep: Step {
        return AppStep.userIsAuthorized
    }
    
    func readyToEmitSteps() {
        //if user is authorised return AppStep.userIsAuthorised
        //GET FROM MODEL!
//        UserDefaults.standard.rx
//            .observe(String.self, "isAuthorised")
//            .filter { $0 == nil }
//            .map { value in
//                return AppStep.userIsUnauthorized }
//            .bind(to: steps)
//            .disposed(by: disposeBag)
    }
    
}
