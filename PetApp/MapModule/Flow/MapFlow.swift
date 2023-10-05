//
//  MapFlow.swift
//  PetApp
//
//  Created by Artur Imanbaev on 20.09.2023.
//

import Foundation
import RxFlow
import RxSwift
final class MapFlow: Flow{
    
    // MARK: - Root
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = MapAssembly().createMapScreen()
    
    // MARK: - Navigate to step
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MapStep else { return .none }
        
        switch step {
        case .mapIsRequired:
            return navigateToMapScreen()
        case .alertIsRequired:
            return showAlertMessage()
        }
    }
    
    private func navigateToMapScreen() -> FlowContributors {
        let mapViewController = MapAssembly().createMapScreen()
        self.rootViewController.navigationController?.pushViewController(mapViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: mapViewController, withNextStepper: mapViewController.viewModel))
    }
    private func showAlertMessage() -> FlowContributors{
        let alertViewController = MapAssembly().createAlertMessage()
        self.rootViewController.present(alertViewController, animated: true)
        return .none
    }

}
