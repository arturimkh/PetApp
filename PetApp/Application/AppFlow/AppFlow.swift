//
//  AppFlow.swift
//  PetApp
//
//  Created by Artur Imanbaev on 20.09.2023.
//

import Foundation
import RxFlow
import RxSwift
import UIKit
class AppFlow: Flow{
    
    // MARK: - Root
    var root: Presentable{
        return self.rootViewController
    }
    
    private let rootViewController: UINavigationController  = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        return navigationController
    }()
    
    //MARK: - navigate to
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {return .none}
        
        switch step {
        case .userIsAuthorized:
            return navigateToMapScreen()
        case .userIsUnauthorized:
            return navigateToMapScreen()
        }
    }
    
    private func navigateToMapScreen() -> FlowContributors {
        let mapFlow = MapFlow()
        Flows.use(mapFlow, when: .created) { root in
            self.rootViewController.pushViewController(root, animated: false)
        }
        guard let mapViewController =  mapFlow.root as? MapViewController else { return .none }
        return .one(flowContributor: .contribute(withNextPresentable: mapFlow, withNextStepper: mapViewController.viewModel))
    }
}
