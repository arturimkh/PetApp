//
//  AppDelegate.swift
//  PetApp
//
//  Created by Sergei Smirnov on 06.09.2023.
//

import UIKit
import RxFlow
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    let disposeBag = DisposeBag()
    
    var window: UIWindow?
    
    var coordinator = FlowCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let appFlow = AppFlow()
        let appStepper = AppStepper()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        self.coordinator.coordinate(flow: appFlow,with: appStepper)

        Flows.use(appFlow, when: .created) { [weak self] root in
            guard let window = self?.window else {return}
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        return true
    }

}

