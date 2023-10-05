//
//  MapAssembly.swift
//  PetApp
//
//  Created by Artur Imanbaev on 20.09.2023.
//

import Foundation
import UIKit
import RxSwift
final class MapAssembly{
    func createMapScreen() -> MapViewController {
        let mapService = MapService()
        let mapViewModel = MapViewModel(mapService: mapService)
        let mapViewController = MapViewController(viewModel: mapViewModel)
        return mapViewController
    }
}
